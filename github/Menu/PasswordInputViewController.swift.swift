//
//  PasswordInputViewController.swift.swift
//  github
//
//  Created by М Й on 02.03.2025.
//

import UIKit

// Protocol to handle password input completion
protocol PasswordInputDelegate: AnyObject {
    func didSetPassword(_ password: String)
    func didEnterPassword(_ password: String)
}

class PasswordInputViewController: UIViewController {
    
    weak var delegate: PasswordInputDelegate?
    var isSettingPassword: Bool = false // Flag to determine if we are setting a password

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24) // Increase font size for better visibility
        return label
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Введите пароль"
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.layer.borderColor = UIColor.green.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.paddingLeft(10) // Add padding
        return textField
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Bold font for button text
        return button
    }()

    private let errorIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle") // Use a system icon
        imageView.tintColor = .red
        imageView.isHidden = true // Initially hidden
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
        view.addSubview(errorIcon)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        errorIcon.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = isSettingPassword ? "Установить пароль" : "Введите пароль"

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50), // Fixed height for better appearance

            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            actionButton.widthAnchor.constraint(equalToConstant: 150), // Fixed width for consistency
            actionButton.heightAnchor.constraint(equalToConstant: 40), // Fixed height for button

            errorIcon.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            errorIcon.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            errorIcon.widthAnchor.constraint(equalToConstant: 30),
            errorIcon.heightAnchor.constraint(equalToConstant: 30)
        ])

        actionButton.addTarget(self, action: #selector(submitPassword), for: .touchUpInside)
    }

    @objc private func submitPassword() {
        guard let password = passwordTextField.text, !password.isEmpty else {
            // Optionally show an alert if the password is empty
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите пароль.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        if isSettingPassword {
            delegate?.didSetPassword(password)
            dismiss(animated: true, completion: nil)
        } else {
            // Here we should check the password against the stored password
            if let storedPassword = UserDefaults.standard.string(forKey: "userPassword"), password == storedPassword {
                delegate?.didEnterPassword(password)
                dismiss(animated: true, completion: nil)
            } else {
                // Show error icon for incorrect password
                errorIcon.isHidden = false
            }
        }
    }
}

// Extension to add padding to UITextField
extension UITextField {
    func paddingLeft(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
