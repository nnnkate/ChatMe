import UIKit
import SnapKit

final class SplashViewController: UIViewController {
	// - UI
	private lazy var backgroungView = { // TODO: add animation
		let view = UIView()
		return view
	}()

	// - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
}

// MARK: - Configure
private extension SplashViewController {
	func configure() {
		addSubviews()
		makeConstraints()
		DispatchQueue.main.async { [weak self] in
			self?.showMain()
		}
	}
	
	func addSubviews() {
		view.addSubview(backgroungView)
	}
	
	func makeConstraints() {
		backgroungView.snp.makeConstraints {
			$0.top.leading.trailing.bottom.equalToSuperview()
		}
	}
}

