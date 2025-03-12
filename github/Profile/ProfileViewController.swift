//
//  Untitled.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Property для хранения пароля пользователя
    private var userPassword: String? {
        get {
            return UserDefaults.standard.string(forKey: "userPassword")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userPassword")
        }
    }
    
    // Представление, которое будет выдвигаться для дополнительных кнопок
    private var expandableButtonView: UIView!
    private var isExpanded = false // Состояние развернутости панели
    private var expandableWidthConstraint: NSLayoutConstraint? // Ограничение по ширине для обновления анимации
    private var setPasswordButton: UIButton! // Ссылка на кнопку "Set Password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Создаем нижнюю панель
        let bottomPanel = UIView()
        bottomPanel.backgroundColor = .black
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomPanel)
        
        NSLayoutConstraint.activate([
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.topAnchor.constraint(equalTo: view.topAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Создаем основную кнопку
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Autoriz")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 150),
            
            imageView.topAnchor.constraint(equalTo: button.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Создаем выдвижную панель
        createExpandableButtonView()
        
        // Создаем кнопку для переключения состояния выдвижной панели
        let toggleButton = UIButton(type: .system)
        toggleButton.setImage(UIImage(systemName: "gear"), for: .normal)
        toggleButton.tintColor = .green
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            toggleButton.topAnchor.constraint(equalTo: bottomPanel.bottomAnchor, constant: -150)
        ])
        
        toggleButton.addTarget(self, action: #selector(toggleExpandableView), for: .touchUpInside)
    }
    
    private func createExpandableButtonView() {
        // Инициализация выдвижного представления
        expandableButtonView = UIView()
        expandableButtonView.backgroundColor = .clear
        expandableButtonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expandableButtonView)
        
        // Устанавливаем начальные ограничения: привязка к правому краю, верхняя отступ 100, начальная ширина 0
        expandableWidthConstraint = expandableButtonView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            expandableButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            expandableWidthConstraint!,
            expandableButtonView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Создаем кнопку "Set Password" и добавляем ее внутрь выдвижной панели
        setPasswordButton = UIButton(type: .system)
        setPasswordButton.setImage(UIImage(systemName: "lock"), for: .normal)
        setPasswordButton.tintColor = .green
        setPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        setPasswordButton.isHidden = true // Скрываем кнопку изначально
        expandableButtonView.addSubview(setPasswordButton)
        
        // Центрируем кнопку внутри выдвижной панели
        NSLayoutConstraint.activate([
            setPasswordButton.centerXAnchor.constraint(equalTo: expandableButtonView.centerXAnchor),
            setPasswordButton.centerYAnchor.constraint(equalTo: expandableButtonView.centerYAnchor)
        ])
        
        setPasswordButton.addTarget(self, action: #selector(setPasswordTapped), for: .touchUpInside)
    }
    
    @objc func toggleExpandableView() {
        // Переключаем флаг развернутости
        isExpanded.toggle()
        
        // При развернутом состоянии устанавливаем ширину, например, 150, иначе 0
        let newWidth: CGFloat = isExpanded ? 50 : 0
        UIView.animate(withDuration: 0.3) {
            self.expandableWidthConstraint?.constant = newWidth
            
            // Появление или исчезновение кнопки "Set Password"
            self.setPasswordButton.isHidden = !self.isExpanded
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func buttonTapped() {
        // Переход к MenuViewController без необходимости вводить пароль
        navigateToMenu()
    }
    
    @objc func setPasswordTapped() {
        let alert = UIAlertController(title: userPassword == nil ? "Добавить пароль" : "Обновить пароль",
                                      message: userPassword == nil ? "Введите пароль!" : "Введите новый пароль!",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        let setAction = UIAlertAction(title: "Set", style: .default) { [weak self] _ in
            if let password = alert.textFields?.first?.text, !password.isEmpty {
                self?.userPassword = password // Сохраняем новый пароль
            }
        }
        alert.addAction(setAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func navigateToMenu() {
        // Предполагается, что MenuViewController – следующий контроллер
        let menuViewController = MenuViewController() // Инициализируйте его как требуется
        navigationController?.pushViewController(menuViewController, animated: true)
    }
}
