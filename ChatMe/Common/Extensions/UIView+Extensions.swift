import UIKit

// MARK: - Shadow
extension UIView {
	func addShadow(color: UIColor = .black,
				   opacity: Float = 0.05,
				   radius: CGFloat = 15,
				   width: CGFloat = 0,
				   height: CGFloat = 2) {
		layer.shadowColor = color.cgColor
		layer.shadowOpacity = opacity
		layer.shadowRadius = radius
		layer.shadowOffset = CGSize(width: width, height: height)
	}
}
