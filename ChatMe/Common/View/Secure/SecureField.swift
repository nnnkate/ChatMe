import UIKit

final class SecureField: UITextField {
	// - Data
	weak var secureContainer: UIView? {
		let secureView = self.subviews
			.filter { subview in
				type(of: subview).description().contains("CanvasView")
			}
			.first
		secureView?.translatesAutoresizingMaskIntoConstraints = false
		secureView?.isUserInteractionEnabled = true
		return secureView
	}
	
	// - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: .zero)
		self.isSecureTextEntry = true
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var canBecomeFirstResponder: Bool {false}
	override func becomeFirstResponder() -> Bool {false}
}
