import Foundation

private enum Key: String {
	case userId = "user_id"
	case userName = "user_name"
}

final class UserDefaultsManager: NSObject {
	// - Shared
	static let shared = UserDefaultsManager()
	
	// - Standard
	private let standard = UserDefaults.standard
	
	// - Lifecycle
	private override init() {
		super.init()
	}
}

// MARK: - Public
extension UserDefaultsManager {
	var userId: String {
		set { save(value: newValue, key: .userId) }
		get { get(key: .userId) }
	}
	
	var userName: String {
		set { save(value: newValue, key: .userName) }
		get { get(key: .userName) }
	}
}

// MARK: - Save
private extension UserDefaultsManager {
	func save(value: String, key: Key) {
		standard.set(value, forKey: key.rawValue)
	}
}

// MARK: - Get
private extension UserDefaultsManager {
	func get(key: Key) -> String {
		standard.string(forKey: key.rawValue) ?? ""
	}
}
