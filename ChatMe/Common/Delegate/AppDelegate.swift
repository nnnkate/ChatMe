import UIKit

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
		FirebaseManager.shared.configure()
	}
}
