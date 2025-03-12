import UIKit

class PreAutoViewController: UIViewController, PasswordInputDelegate {
    
    // Property to store the user's password
    private var userPassword: String? {
        get {
            return UserDefaults.standard.string(forKey: "userPassword")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userPassword")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black // Setting the background color to black
        
        // Creating UIImageView and adding an image
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Autoriz") // Name of your image
        imageView.contentMode = .scaleAspectFit // Setting the image display mode
        imageView.frame = CGRect(x: 0, y: 250, width: 150, height: 150) // Setting coordinates and size
        imageView.center.x = view.center.x // Centering x
        view.addSubview(imageView)

        // Creating a label
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.textAlignment = .center
        label.numberOfLines = 0 // Allows the label to use multiple lines
        label.frame = CGRect(x: 0, y: 420, width: 300, height: 0) // Setting width, height will be calculated automatically
        label.sizeToFit() // Automatically adjusts the height of the label to fit the text
        label.center.x = view.center.x
        label.textColor = .gray // Setting text color
        view.addSubview(label)
        
        // Creating a button
        let preAutoButton = UIButton(type: .system)
        preAutoButton.setTitle("Продолжить", for: .normal)
        preAutoButton.addTarget(self, action: #selector(preAutoButtonTapped), for: .touchUpInside)
        
        // Configuring the button appearance
        preAutoButton.backgroundColor = UIColor.systemBlue // Background color
        preAutoButton.setTitleColor(.white, for: .normal) // Text color
        preAutoButton.layer.cornerRadius = 10 // Rounding corners
        preAutoButton.frame = CGRect(x: 0, y: 750, width: 150, height: 40)
        preAutoButton.center.x = view.center.x // Centering x
        view.addSubview(preAutoButton)
    }
    
    @objc private func preAutoButtonTapped() {
        // Check if password exists and prompt for input accordingly
        if let _ = userPassword {
            // If password exists, prompt for password input
            showPasswordInput(isSettingPassword: false)
        } else {
            // If password does not exist, prompt to set a password
            showPasswordInput(isSettingPassword: true)
        }
    }

    private func showPasswordInput(isSettingPassword: Bool) {
        let passwordVC = PasswordInputViewController()
        passwordVC.isSettingPassword = isSettingPassword
        passwordVC.delegate = self
        passwordVC.modalPresentationStyle = .overFullScreen // Optional for visual effect
        present(passwordVC, animated: true)
    }

    // MARK: - PasswordInputDelegate methods
    func didSetPassword(_ password: String) {
        userPassword = password
    }

    func didEnterPassword(_ password: String) {
        if password == userPassword {
            navigateToMenu()
        } else {
            // Show an alert for incorrect password
            let alert = UIAlertController(title: "Ошибка", message: "Неверный пароль. Попробуйте снова.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    private func navigateToMenu() {
        // Assuming MenuViewController is the next view controller
        let menuViewController = MenuViewController()
        // Заменяем стек навигационных контроллеров, чтобы убрать возможность возврата
        navigationController?.setViewControllers([menuViewController], animated: true)
    }
}

