import UIKit

// MARK: - Screens
extension UIViewController {
	func showMain() {
		let isUserExist = !UserDefaultsManager.shared.userId.isEmpty
		navigationController?.pushViewController(isUserExist ? MainViewController() : UserViewControlller(), animated: false)
	}
	
	func showChat(_ chat: Chat) {
		let vc = ChatViewController()
		vc.set(chat: chat)
		navigationController?.pushViewController(vc, animated: false)
	}
}
