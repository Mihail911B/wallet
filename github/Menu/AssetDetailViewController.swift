

import UIKit

class AssetDetailViewController: UIViewController {
    var currency: String?
    var amount: Double?
    weak var delegate: AssetDetailViewControllerDelegate?

    private let currencyLabel = UILabel()
    private let amountTextField = UITextField()
    private let updateButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)
    private let hiLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Настройка меток и текстового поля
        currencyLabel.textColor = .white
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        hiLabel.textColor = .white
        hiLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.textColor = .black
        amountTextField.backgroundColor = .white
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        
        // Установка текста метки
        currencyLabel.text = "Валюта: \(currency ?? "N/A")"
        amountTextField.text = amount != nil ? String(format: "%.2f", amount!) : "0.00"
        
        
        hiLabel.text = "Редактируйте свои активы!"
        
        // Настройка кнопок
        updateButton.setTitle("Обновить", for: .normal)
        updateButton.addTarget(self, action: #selector(updateAmount), for: .touchUpInside)
        updateButton.backgroundColor = .green
        updateButton.tintColor = .white
        updateButton.layer.cornerRadius = 10

        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAsset), for: .touchUpInside)
        deleteButton.backgroundColor = .red
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 10
        
        // Добавление представлений
        view.addSubview(currencyLabel)
        view.addSubview(amountTextField)
        view.addSubview(updateButton)
        view.addSubview(deleteButton)
        view.addSubview(hiLabel)
        
        // Размещение элементов на экране
        setupLayout()
    }
    
    private func setupLayout() {
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        hiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currencyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            hiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            
            amountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amountTextField.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 10),
            amountTextField.widthAnchor.constraint(equalToConstant: 200),
            
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            updateButton.widthAnchor.constraint(equalToConstant: 100),
            updateButton.heightAnchor.constraint(equalToConstant: 40),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    @objc private func updateAmount() {
        guard let text = amountTextField.text,
              let newAmount = Double(text) else {
            let alert = UIAlertController(title: "Ошибка", message: "Введите корректное количество.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }
        
        delegate?.didUpdateAsset(currency: currency ?? "N/A", amount: newAmount)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAsset() {
        delegate?.didDeleteAsset(currency: currency ?? "N/A")
        navigationController?.popViewController(animated: true)
    }
}

