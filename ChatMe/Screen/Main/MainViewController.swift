import UIKit

final class MainViewController: UIViewController {
	// - UI
	private lazy var titleLabel = {
		let view = UILabel()
		view.font = .bold(20)
		view.textColor = .black
		view.text = "chats".localized
		return view
	}()
	private lazy var tableView = {
		let view = UITableView(frame: .zero)
		view.sectionHeaderTopPadding = 0
		view.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
		view.separatorStyle = .none
		view.showsVerticalScrollIndicator = false
		view.layer.masksToBounds = true
		view.clipsToBounds = true
		view.backgroundColor = .clear
		return view
	}()
	
	// - DataSource
	private var dataSource: MainDataSource?
	
	// - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		load()
	}
}

// MARK: - DataSource
private extension MainViewController {
	func configureDataSource() {
		dataSource = MainDataSource(tableView: tableView)
		dataSource?.openChatActionHandler = { [weak self] chat in
			self?.showChat(chat)
		}
	}
}

// MARK: - Configure
private extension MainViewController {
	func load() {
		let manager = FirebaseManager.shared
		manager.updateChatsActionHandler = { [weak self] chats in
			self?.dataSource?.set(chats: chats.reversed())
		}
		manager.loadData()
	}
}
	
// MARK: - Configure
private extension MainViewController {
	func configure() {
		configureUI()
		addSubviews()
		makeConstraints()
		configureDataSource()
		FirebaseManager.shared.listenForChats()
	}
	
	func configureUI() {
		view.backgroundColor = .white
	}
	
	func addSubviews() {
		view.addSubview(titleLabel)
		view.addSubview(tableView)
	}
	
	func makeConstraints() {
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
			$0.centerX.equalToSuperview()
		}
		
		tableView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
		}
	}
}

