import UIKit

final class ChatDataSource: NSObject {
	// - TableView
	private(set) unowned var tableView: UITableView
	
	// - Data
	private var messages = [Message]()
	
	// - Lifecycle
	init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
		configure()
	}
}

// MARK: - Set
extension ChatDataSource {
	func set(messages: [Message]) {
		self.messages = messages
		reloadData()
		
		if self.messages.count > 0 {
			let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
			self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
		}
	}
}
	
// MARK: - UITableViewDataSource
extension ChatDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = messages[indexPath.row]
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID, for: indexPath) as? MessageCell {
			cell.set(message: message)
			return cell
		}
		
		return UITableViewCell()
	}
}

// MARK: - Reload
extension ChatDataSource {
	func reloadData() {
		tableView.reloadData()
	 }
}

// MARK: - Configure
private extension ChatDataSource {
	func configure() {
		registerCells()
		tableView.dataSource = self
	}
}

// MARK: - Register
private extension ChatDataSource {
	 func registerCells() {
		 tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseID)
	 }
}
