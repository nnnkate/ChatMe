import UIKit
import IQKeyboardManagerSwift

final class UserViewControlller: UIViewController {
	// - UI
	private lazy var nameLabel = {
		let view = UILabel()
		view.font = .light(16)
		view.textColor = .black
		view.text = "name_title".localized
		return view
	}()
	private lazy var nameBackgroundView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .mainBackground
		return view
	}()
	private lazy var nameTextField = {
		let view = UITextField()
		view.font = .regular(18)
		view.textColor = .black
		let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainText.withAlphaComponent(0.75),
														 .font: UIFont.light(16)]
		view.attributedPlaceholder = NSAttributedString(string: "name_ph".localized,
														attributes: attributes)
		view.delegate = self
		return view
	}()
	private lazy var emailLabel = {
		let view = UILabel()
		view.font = .light(16)
		view.textColor = .black
		view.text = "email_title".localized
		return view
	}()
	private lazy var emailBackgroundView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .mainBackground
		return view
	}()
	private lazy var emailTextField = {
		let view = UITextField()
		view.font = .regular(18)
		view.textColor = .black
		let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainText.withAlphaComponent(0.75),
														 .font: UIFont.light(16)]
		view.attributedPlaceholder = NSAttributedString(string: "email_ph".localized,
														attributes: attributes)
		view.delegate = self
		return view
	}()
	private lazy var passwordLabel = {
		let view = UILabel()
		view.font = .light(16)
		view.textColor = .black
		view.text = "password_title".localized
		return view
	}()
	private lazy var passwordBackgroundView = {
		let view = UIView()
		view.layer.cornerRadius = 16
		view.backgroundColor = .mainBackground
		return view
	}()
	private lazy var passwordTextField = {
		let view = UITextField()
		view.font = .regular(18)
		view.textColor = .black
		view.isSecureTextEntry = true
		let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainText.withAlphaComponent(0.75),
														 .font: UIFont.light(16)]
		view.attributedPlaceholder = NSAttributedString(string: "password_ph".localized,
														attributes: attributes)
		view.delegate = self
		return view
	}()
	private lazy var signInButton = {
		let view = UIButton()
		view.backgroundColor = .black
		view.layer.cornerRadius = 25
		view.titleLabel?.font = .extraBold(20)
		let title = "sign_in".localized
		view.setTitle(title, for: .normal)
		view.setTitle(title, for: .highlighted)
		view.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
		return view
	}()
	private lazy var signUpButton = {
		let view = UIButton()
		view.backgroundColor = .black
		view.layer.cornerRadius = 25
		view.titleLabel?.font = .extraBold(20)
		let title = "sign_up".localized
		view.setTitle(title, for: .normal)
		view.setTitle(title, for: .highlighted)
		view.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
		return view
	}()
	private lazy var loader = {
		let view = UIActivityIndicatorView(style: .medium)
		view.color = .black
		view.hidesWhenStopped = true
		return view
	}()
	
	// - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		IQKeyboardManager.shared.isEnabled = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.shared.isEnabled = false
	}
}

// MARK: - Loader
private extension UserViewControlller {
	func startLoading() {
		loader.startAnimating()
		signInButton.isHidden = true
		signUpButton.isHidden = true
	}
	
	func stopLoading() {
		loader.stopAnimating()
		signInButton.isHidden = false
		signUpButton.isHidden = false
	}
}

// MARK: - Actions
private extension UserViewControlller {
	@objc func signInAction() {
		checkFields { [weak self] in
			guard let self else { return }
			self.startLoading()
			FirebaseManager.shared.signIn(email: self.emailTextField.text ?? "",
										  password: self.passwordTextField.text ?? "") { result in
				result ? self.showMain() : self.stopLoading()
			}
		}
	}
	
	@objc func signUpAction() {
		checkFields { [weak self] in
			guard let self else { return }
			FirebaseManager.shared.signUp(name: self.nameTextField.text ?? "",
										  email: self.emailTextField.text ?? "",
										  password: self.passwordTextField.text ?? "") { result in
				result ? self.showMain() : self.stopLoading()
			}
		}
	}
	
	func checkFields(completion: (() -> Void)?) { // TODO:
		nameTextField.resignFirstResponder()
		emailTextField.resignFirstResponder()
		passwordTextField.resignFirstResponder()
		if nameTextField.text?.isEmpty == true ||
			emailTextField.text?.isEmpty == true ||
			passwordTextField.text?.isEmpty == true {
			// TODO: Show Empty Fields Alert
			return
		}
		completion?()
	}
}

// MARK: - UITextFieldDelegate
extension UserViewControlller: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - Configure
private extension UserViewControlller {
	func configure() {
		configureUI()
		addSubviews()
		makeConstraints()
	}
	
	func configureUI() {
		view.backgroundColor = .white
	}
	
	func addSubviews() {
		view.addSubview(nameLabel)
		view.addSubview(nameBackgroundView)
		nameBackgroundView.addSubview(nameTextField)
		view.addSubview(emailLabel)
		view.addSubview(emailBackgroundView)
		emailBackgroundView.addSubview(emailTextField)
		view.addSubview(passwordLabel)
		view.addSubview(passwordBackgroundView)
		passwordBackgroundView.addSubview(passwordTextField)
		view.addSubview(loader)
		view.addSubview(signInButton)
		view.addSubview(signUpButton)
	}
	
	func makeConstraints() {
		nameLabel.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
			$0.leading.equalTo(24)
			$0.trailing.equalTo(-24)
		}
		
		nameBackgroundView.snp.makeConstraints {
			$0.top.equalTo(nameLabel.snp.bottom).offset(4)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.height.equalTo(52)
		}
		
		nameTextField.snp.makeConstraints {
			$0.top.equalTo(4)
			$0.leading.equalTo(14)
			$0.trailing.equalTo(-14)
			$0.bottom.equalTo(-4)
		}
		
		emailLabel.snp.makeConstraints {
			$0.top.equalTo(nameBackgroundView.snp.bottom).offset(15)
			$0.leading.equalTo(24)
			$0.trailing.equalTo(-24)
		}
		
		emailBackgroundView.snp.makeConstraints {
			$0.top.equalTo(emailLabel.snp.bottom).offset(4)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.height.equalTo(52)
		}
		
		emailTextField.snp.makeConstraints {
			$0.top.equalTo(4)
			$0.leading.equalTo(14)
			$0.trailing.equalTo(-14)
			$0.bottom.equalTo(-4)
		}
		
		passwordLabel.snp.makeConstraints {
			$0.top.equalTo(emailBackgroundView.snp.bottom).offset(15)
			$0.leading.equalTo(24)
			$0.trailing.equalTo(-24)
		}
		
		passwordBackgroundView.snp.makeConstraints {
			$0.top.equalTo(passwordLabel.snp.bottom).offset(4)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.height.equalTo(52)
		}
		
		passwordTextField.snp.makeConstraints {
			$0.top.equalTo(4)
			$0.leading.equalTo(14)
			$0.trailing.equalTo(-14)
			$0.bottom.equalTo(-4)
		}
		
		signInButton.snp.makeConstraints {
			$0.height.equalTo(64)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.bottom.equalTo(signUpButton.snp.top).offset(-10)
		}
		
		signUpButton.snp.makeConstraints {
			$0.height.equalTo(64)
			$0.leading.equalTo(16)
			$0.trailing.equalTo(-16)
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
		}
		
		loader.snp.makeConstraints {
			$0.center.equalTo(signUpButton.snp.center)
		}
	}
}
