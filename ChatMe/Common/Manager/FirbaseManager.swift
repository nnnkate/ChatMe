import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseRemoteConfig

private enum Key: String {
	// - Base
	case users = "users"
	case messages = "messages"
	
	// - Users
	case userId = "user_id"
	case userName = "user_name"

	// - Messages
	case senderId = "sender_id"
	case recepientId = "recepient_id"
	case createAt = "create_at"
	case text = "text"
	
	// - Config
	case isScreenshotEnabled = "is_screenshot_enabled"
}

// TODO: add remote
final class FirebaseManager {
	// - Shared
	static let shared = FirebaseManager()
	
	// - Auth
	private lazy var auth = Auth.auth()
	
	// - Firestore
	private lazy var firestore = Firestore.firestore()
	
	// - Config
	private(set) var config: RemoteConfig?
	
	// - UserDefaults
	private lazy var userDefaultsManager = UserDefaultsManager.shared // TODO: Dependency Injection
	
	// - Data
	var isScreenshotEnabled = false

	// - Handler
	var updateChatsActionHandler: (([Chat]) -> Void)?

	// - Lifecycle
	private init() {}
}

// MARK: - Configure
extension FirebaseManager {
	func configure() {
		FirebaseApp.configure()
		configureRemoteConfig()
	}
}

// MARK: - Load
extension FirebaseManager {
	func loadData() {
		let userId = self.userDefaultsManager.userId
		getUsers { [weak self] users in
			guard let self else { return }
			self.getMessages { messages in
				let data = users.map { user in
					Chat(user: user,
						 messages: messages.filter { ($0.senderId == user.id && $0.recepientId == userId) || ($0.recepientId == user.id && $0.senderId == userId) })
				}
				
				self.updateChatsActionHandler?(data)
			}
		}
	}
}

// MARK: - Registration
extension FirebaseManager {
	func signUp(name: String,
				email: String,
				password: String,
				completion: ((_ result: Bool) -> Void)?) {
		auth.createUser(withEmail: email, password: password) { [weak self] result, error in
			guard let self, error == nil else {
				print("Registration error: \(error?.localizedDescription ?? "Error")") // TODO: add error handler
				completion?(false)
				return
			}
			
			if let uid = result?.user.uid {
				self.createUser(uid: uid, name: name) { completion?(true) }
			} else { completion?(false) }
		}
	}
	
	func signIn(email: String,
				password: String,
				completion: ((_ result: Bool) -> Void)?) {
		auth.signIn(withEmail: email,
					password: password) { [weak self] result, error in
			guard let self, error == nil else {
				print("Login error: \(error?.localizedDescription ?? "Error")") // TODO: add error handler
				completion?(false)
				return
			}
			
			if let uid = result?.user.uid {
				self.getUser(uid: uid) { completion?(true) }
			} else { completion?(false) }
		}
	}
}


// MARK: - Send
extension FirebaseManager {
	func send(to recepientId: String, message: String) {
		firestore.collection(Key.messages.rawValue)
			.addDocument(data: [
				Key.senderId.rawValue: userDefaultsManager.userId,
				Key.recepientId.rawValue: recepientId,
				Key.text.rawValue: message,
				Key.createAt.rawValue: Timestamp(date: Date())
			]) { error in
				if let error {
					print("Send error: \(error.localizedDescription)") // TODO: add error handler
					return
				}
			}
	}
}
	
// MARK: - Listener
extension FirebaseManager {
	func listenForMessages(completion: ((Message) -> Void)?) {
		firestore.collection(Key.messages.rawValue)
			.order(by: Key.createAt.rawValue)
			.addSnapshotListener { querySnapshot, error in  // TODO: add error handler
				guard let documents = querySnapshot?.documents else {
					return
				}
				
				documents.forEach { document in
					self.mapToMessage(document.data(), id: document.documentID, completion: completion)
				}
			}
	}
	
	func listenForChats() {
		firestore.collection(Key.messages.rawValue)
			.order(by: Key.createAt.rawValue)
			.addSnapshotListener { [weak self] querySnapshot, error in  // TODO: add error handler
				guard let self, let documents = querySnapshot?.documents, error == nil else {
					print("Error: \(error?.localizedDescription ?? "Error")") // TODO: add error handler
					return
				}
				
				self.loadData()  // TODO: documents map to messages
			}
	}
}

// MARK: - Helper
private extension FirebaseManager {
	func mapToMessage(_ data: [String: Any], id: String, completion: ((Message) -> Void)?) {
		let userId = userDefaultsManager.userId
		let senderId = data[Key.senderId.rawValue] as? String ?? ""
		let recepientId = data[Key.recepientId.rawValue] as? String ?? ""
		let date = (data[Key.createAt.rawValue] as? Timestamp)?.dateValue() ?? Date()
		let text = data[Key.text.rawValue] as? String ?? ""
		if senderId == userId || recepientId == userId {
			completion?(Message(id: id, senderId: senderId, recepientId: recepientId, date: date, text: text))
		}
	}
}

// MARK: - User
private extension FirebaseManager {
	func createUser(uid: String,
					name: String,
					completion: (() -> Void)?) {
		saveUser(uid: uid, name: name)
		
		let data: [String: Any] = [Key.userId.rawValue: uid,
								   Key.userName.rawValue: name]
		
		firestore.collection(Key.users.rawValue)
			.document(uid)
			.setData(data) { result in
				completion?()
		}
	}
	
	func getUser(uid: String,
				 completion: (() -> Void)?) {
		getUsers { [weak self] users in
			guard let self else { return }
			if let user = users.first(where: { $0.id == uid }) {
				self.saveUser(uid: uid, name: user.name)
				completion?()
			}
		}
	}
	
	func saveUser(uid: String, name: String) {
		userDefaultsManager.userId = uid
		userDefaultsManager.userName = name
	}
}

// MARK: - Chats
private extension FirebaseManager {
	func getMessages(completion: (([Message]) -> Void)?) {
		firestore.collection(Key.messages.rawValue)
			.order(by: Key.createAt.rawValue)
			.getDocuments() { [weak self] documents, error in
				guard let self, let documents else {  // TODO: Add error handler
					completion?([])
					return
				}
				
				let messages: [Message] = documents.documents.compactMap { document in
					let data = document.data()
					let senderId = data[Key.senderId.rawValue] as? String ?? ""
					let recepientId = data[Key.recepientId.rawValue] as? String ?? ""
					let userId = self.userDefaultsManager.userId
					if senderId == userId || recepientId == userId {
						return Message(
							id: document.documentID,
							senderId: senderId,
							recepientId: recepientId,
							date: (data[Key.createAt.rawValue] as? Timestamp)?.dateValue() ?? Date(),
							text: data[Key.text.rawValue] as? String ?? ""
						)
					} else {
						return nil
					}
				}
				
				completion?(messages)
			}
	}
}

// MARK: - Users
private extension FirebaseManager {
	func getUsers(completion: (([User]) -> Void)?) {
		firestore.collection(Key.users.rawValue)
			.getDocuments() { [weak self] documents, error in
				guard let self, let documents  else {  // TODO: Add error handler
					completion?([])
					return
				}
				
				let users: [User] = documents.documents.compactMap { document in
					let data = document.data()
					let userId = data[Key.userId.rawValue] as? String ?? ""
					if userId == self.userDefaultsManager.userId {
						return nil
					} else {
						let userName = data[Key.userName.rawValue] as? String ?? ""
						return User(id: userId, name: userName)
					}
				}
				
				completion?(users)
			}
	}
}

// MARK: - Config
private extension FirebaseManager {
	func configureRemoteConfig() {
		config = RemoteConfig.remoteConfig()
		let settings = RemoteConfigSettings()
		settings.minimumFetchInterval = 0
		config?.configSettings = settings
		config?.fetch() { [weak self] _, _  in
			guard let self, let config else { return }
			config.activate { _, error in
				self.isScreenshotEnabled = config[Key.isScreenshotEnabled.rawValue].boolValue
			}
		}
	}
}
