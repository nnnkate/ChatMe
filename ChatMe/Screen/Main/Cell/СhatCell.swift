import UIKit

final class ChatCell: UITableViewCell {
	// - ID
	static let reuseID = "СhatCell"
	
	// - UI
	private lazy var mainView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.layer.borderColor = UIColor.mainSubtitle.cgColor
		view.layer.borderWidth = 1
		view.backgroundColor = .white
		view.addShadow()
		return view
	}()
	private lazy var userImageView = {
		let view = UIImageView()
		view.layer.cornerRadius = 20
		view.layer.borderColor = UIColor.mainSubtitle.cgColor
		view.layer.borderWidth = 1
		view.backgroundColor = .mainBackground
		return view
	}()
	private lazy var initialsLabel = {
		let view = UILabel()
		view.textColor = .black
		view.font = .bold(20)
		return view
	}()
	private lazy var nameLabel = {
		let view = UILabel()
		view.textColor = .black
		view.font = .bold(18)
		return view
	}()
	private lazy var messageLabel = {
		let view = UILabel()
		view.textColor = .mainSubtitle
		view.font = .regular(16)
		return view
	}()
	
	// - Data
	private var chat: Chat?
	
	// - Lifecycle
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		configure()
	}
}

// MARK: - Set
extension ChatCell {
	func set(chat: Chat) {
		self.chat = chat
		let name = chat.user.name
		nameLabel.text = name
		messageLabel.text = chat.messages.last?.text ?? "empty_message".localized
		initialsLabel.text = getInitials(from: name)
	}
}

// MARK: - Helper
private extension ChatCell {
	func getInitials(from name: String) -> String {
		let initials = name.components(separatedBy: " ").compactMap { word in
			return word.first.map { String($0).uppercased() }
		}
		
		return initials.joined()
	}

}

// MARK: - Configure
private extension ChatCell {
	func configure() {
		configureUI()
		addSubviews()
		makeConstraints()
	}
	
	func configureUI() {
		selectionStyle = .none
	}
	
	func addSubviews() {
		contentView.addSubview(mainView)
		mainView.addSubview(userImageView)
		userImageView.addSubview(initialsLabel)
		mainView.addSubview(nameLabel)
		mainView.addSubview(messageLabel)
	}
	
	func makeConstraints() {
		mainView.snp.makeConstraints {
			$0.height.equalTo(62)
			$0.top.equalToSuperview()
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.bottom.equalTo(-8)
		}
		
		userImageView.snp.makeConstraints {
			$0.height.width.equalTo(40)
			$0.width.equalTo(50)
			$0.top.equalTo(11)
			$0.leading.equalTo(12)
			$0.bottom.equalTo(-11)
		}
		
		initialsLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
		
		nameLabel.snp.makeConstraints {
			$0.top.equalTo(11.5)
			$0.leading.equalTo(userImageView.snp.trailing).offset(12)
			$0.trailing.equalTo(-12)
			
		}
		
		messageLabel.snp.makeConstraints {
			$0.leading.equalTo(userImageView.snp.trailing).offset(12)
			$0.trailing.equalTo(-12)
			$0.bottom.equalTo(-11.5)
		}
	}
}
