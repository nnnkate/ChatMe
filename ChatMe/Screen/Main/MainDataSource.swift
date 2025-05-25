import UIKit

final class MainDataSource: NSObject {
	// - TableView
	private(set) unowned var tableView: UITableView
	
	// - Data
	private var chats = [Chat]()
	
	// - Action
	var openChatActionHandler: ((Chat) -> Void)?
	
	// - Lifecycle
	init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
		configure()
	}
}

// MARK: - Set
extension MainDataSource {
	func set(chats: [Chat]) {
		self.chats = chats
		reloadData()
	}
}
	
// MARK: - UITableViewDataSource
extension MainDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		chats.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		chatCell(cellForRowAt: indexPath) ?? UITableViewCell()
	}
}

// MARK: - UITableViewDelegate
extension MainDataSource: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row >= chats.count {
			return
		}
		
		openChatActionHandler?(chats[indexPath.row])
	}
}

// MARK: - Cell
private extension MainDataSource {
	func chatCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
		let chat = chats[indexPath.row]
		if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseID, for: indexPath) as? ChatCell {
			cell.set(chat: chat)
			return cell
		}
		return UITableViewCell()
	}
}

// MARK: - Reload
extension MainDataSource {
	func reloadData() {
		tableView.reloadData()
	 }
}

// MARK: - Configure
private extension MainDataSource {
	func configure() {
		registerCells()
		tableView.dataSource = self
		tableView.delegate = self
	}
}

// MARK: - Register
private extension MainDataSource {
	 func registerCells() {
		 tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseID)
	 }
}
