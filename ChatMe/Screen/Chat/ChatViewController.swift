import UIKit
import IQKeyboardManagerSwift

final class ChatViewController: UIViewController {
	// - UI
	private lazy var backButton = {
		let view = UIButton()
		let image = UIImage(systemName: "chevron.left")
		view.setBackgroundImage(image, for: .normal)
		view.setBackgroundImage(image, for: .highlighted)
		view.tintColor = .black
		view.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
		return view
	}()
	private lazy var titleLabel = {
		let view = UILabel()
		view.font = .boldSystemFont(ofSize: 20)
		view.textColor = .black
		return view
	}()
	private lazy var tableView = {
		let view = UITableView(frame: .zero)
		view.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseID)
		view.separatorStyle = .none
		view.showsVerticalScrollIndicator = false
		return view
	}()
	private lazy var inputContainer = {
		let view = UIView()
		view.backgroundColor = .mainBackground
		return view
	}()
	private lazy var messageTextField = {
		let view = UITextField()
		view.placeholder = "type_ph".localized
		view.borderStyle = .roundedRect
		view.delegate = self
		return view
	}()
	private lazy var sendButton = {
		let view = UIButton()
		let image = UIImage(systemName: "arrow.up.circle.fill")
		view.setBackgroundImage(image, for: .normal)
		view.setBackgroundImage(image, for: .highlighted)
		view.tintColor = .black
		view.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
		return view
	}()
	private lazy var secureView = FirebaseManager.shared.isScreenshotEnabled ? UIView() : (SecureField().secureContainer ?? UIView())

	// - Data
	private var user: User?
	private var messages = [Message]()
	
	// - DataSource
	private var dataSource: ChatDataSource?
	
	// - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		IQKeyboardManager.shared.isEnabled = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.shared.isEnabled = false
	}
}

// MARK: - Set
extension ChatViewController {
	func set(chat: Chat) {
		user = chat.user
		messages = chat.messages
		titleLabel.text = chat.user.name
		listenForMessages()
	}
}

// MARK: - DataSource
private extension ChatViewController {
	func configureDataSource() {
		dataSource = ChatDataSource(tableView: tableView)
		dataSource?.set(messages: messages)
	}
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - Configure
private extension ChatViewController {
	func configure() {
		configureUI()
		addSubviews()
		makeConstraints()
		configureDataSource()
	}
	
	func configureUI() {
		view.backgroundColor = .white
	}
	
	func addSubviews() {
		secureView.addSubview(backButton)
		secureView.addSubview(titleLabel)
		secureView.addSubview(tableView)
		secureView.addSubview(inputContainer)
		inputContainer.addSubview(messageTextField)
		inputContainer.addSubview(sendButton)
		view.addSubview(secureView)
	}
	
	func makeConstraints() {
		backButton.snp.makeConstraints {
			$0.centerY.equalTo(titleLabel.snp.centerY)
			$0.leading.equalTo(16)
			$0.height.equalTo(30)
			$0.width.equalTo(20)
		}
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
			$0.centerX.equalToSuperview()
		}
		
		tableView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(inputContainer.snp.top)
		}
		
		inputContainer.snp.makeConstraints {
			$0.leading.trailing.bottom.equalToSuperview()
		}
		
		messageTextField.snp.makeConstraints {
			$0.top.equalTo(8)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(sendButton.snp.leading).offset(-16)
			$0.height.equalTo(34)
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
		}
		
		sendButton.snp.makeConstraints {
			$0.trailing.equalTo(-16)
			$0.centerY.equalTo(messageTextField.snp.centerY)
			$0.height.width.equalTo(30)
		}
		
		secureView.snp.makeConstraints {
			$0.top.bottom.trailing.leading.equalToSuperview()
		}
	}
}

// MARK: - Actions
private extension ChatViewController {
	@objc func sendButtonAction() {
		guard let user, let message = messageTextField.text, !message.isEmpty else { return }
		FirebaseManager.shared.send(to: user.id, message: message)
		messageTextField.text = nil
	}
	
	@objc func backButtonAction() {
		navigationController?.popViewController(animated: false) // TODO:
	}
}

// MARK: - Listen
private extension ChatViewController {
	func listenForMessages() {
		let userId = UserDefaultsManager.shared.userId
		guard let user else { return }
		FirebaseManager.shared.listenForMessages { [weak self] message in
			guard let self else { return }
			if self.messages.contains(where: { $0.id == message.id }) {
				return
			}
			
			if (message.recepientId == user.id && message.senderId == userId) || (message.senderId == userId && message.recepientId == user.id) {
				self.messages.append(message)
				self.dataSource?.set(messages: self.messages)
			}
		}
	}
}
