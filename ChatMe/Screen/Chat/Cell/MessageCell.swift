import UIKit

final class MessageCell: UITableViewCell {
	// - ID
	static let reuseID = "MessageCell"
	
	// - UI
	private lazy var mainView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .mainBackground
		view.addShadow()
		return view
	}()
	private lazy var messageLabel = {
		let view = UILabel()
		view.textColor = .black
		view.font = .regular(16)
		view.numberOfLines = 0
		return view
	}()
	
	// - Data
	private var message: Message?
	
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
extension MessageCell {
	func set(message: Message) {
		self.message = message
		messageLabel.text = message.text
		remake()
	}
}

// MARK: - Configure
private extension MessageCell {
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
		mainView.addSubview(messageLabel)
	}
	
	func makeConstraints() {
		mainView.snp.makeConstraints {
			$0.top.equalToSuperview()
			$0.leading.equalTo(40)
			$0.trailing.equalTo(-16)
			$0.bottom.equalTo(-8)
		}
		
		messageLabel.snp.makeConstraints {
			$0.top.leading.equalTo(16)
			$0.trailing.bottom.equalTo(-16)
		}
	}
	
	func remake() {
		let isCurrentUser = message?.senderId == UserDefaultsManager.shared.userId
		messageLabel.textAlignment = isCurrentUser ? .right : .left
		mainView.snp.remakeConstraints {
			$0.top.equalToSuperview()
			if isCurrentUser {
				$0.leading.greaterThanOrEqualTo(80).priority(999)
				$0.trailing.equalTo(-16)
			} else {
				$0.leading.equalTo(16)
				$0.trailing.lessThanOrEqualTo(-80).priority(999)
			}
			$0.bottom.equalTo(-8)
		}
	}
}
