import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	// - Window
	var window: UIWindow?
	
	// - Lifecycle
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let window = (scene as? UIWindowScene) else { return }
		self.window = UIWindow(windowScene: window)
		self.window?.overrideUserInterfaceStyle = .light
		showSplash()
	}
}

// MARK: - Localized
private extension SceneDelegate {
	func showSplash() {
		let vc = SplashViewController()
		let nc = UINavigationController()
		nc.viewControllers = [vc]
		vc.modalPresentationStyle = .overCurrentContext
		vc.navigationController?.isNavigationBarHidden = true
		window?.rootViewController = nc
		window?.makeKeyAndVisible()
	}
}
