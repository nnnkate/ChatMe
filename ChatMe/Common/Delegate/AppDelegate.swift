import UIKit
import IQKeyboardManagerSwift

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		configure()
		
		return true
	}
}

// MARK: - Configure
private extension AppDelegate{
	func configure() {
		// - Manager
		FirebaseManager.shared.configure()
		
		// - Keyboard
		IQKeyboardManager.shared.resignOnTouchOutside = true
		IQKeyboardManager.shared.keyboardDistance = 10
	}
}
