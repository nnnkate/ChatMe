import UIKit

// MARK: - Fonts
extension UIFont {
	static func regular(_ size: CGFloat) -> UIFont {
		UIFont(name: "MerriweatherSans-Regular", size: size) ?? .systemFont(ofSize: size)
	}
	
	static func light(_ size: CGFloat) -> UIFont {
		UIFont(name: "MerriweatherSansRoman-Light", size: size) ?? .systemFont(ofSize: size)
	}
	
	static func bold(_ size: CGFloat) -> UIFont {
		UIFont(name: "MerriweatherSansRoman-Bold", size: size) ?? .systemFont(ofSize: size)
	}
	
	static func extraBold(_ size: CGFloat) -> UIFont {
		UIFont(name: "MerriweatherSansRoman-ExtraBold", size: size) ?? .systemFont(ofSize: size)
	}
}
