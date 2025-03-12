import UIKit

// Protocol Declaration
protocol AssetDetailViewControllerDelegate: AnyObject {
    func didUpdateAsset(currency: String, amount: Double)
    func didDeleteAsset(currency: String)
}

// Структура для актива
struct Asset: Codable {
    var currency: String
    var amount: Double
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var progressLayer: CAShapeLayer?
    var trackLayer: CAShapeLayer?
    
    // UITableView для отображения активов (валюта и количество)
    var assetsTableView: UITableView!
    
    // Массив для хранения добавленных активов
    var assets: [Asset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        loadAssets() // Загрузка активов из UserDefaults
        
        setupBottomPanelAndButtons()
        setupAssetsTableView()  // создаём таблицу вместо UIStackView
        
        // Добавляем кнопку "плюс" в правом верхнем углу
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addAsset))
    }

    private func setupBottomPanelAndButtons() {
        let bottomPanel = UIView()
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.backgroundColor = .green
        bottomPanel.layer.cornerRadius = 25
        bottomPanel.clipsToBounds = true
        view.addSubview(bottomPanel)
        
        NSLayoutConstraint.activate([
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            bottomPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomPanel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let messButton = UIButton(type: .system)
        messButton.setImage(UIImage(systemName: "message"), for: .normal)
        messButton.addTarget(self, action: #selector(MessegerButtonTapped), for: .touchUpInside)
        messButton.tintColor = .black
        messButton.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.addSubview(messButton)
        
        let profileButton = UIButton(type: .system)
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)
        profileButton.addTarget(self, action: #selector(ProfileButtonTapped), for: .touchUpInside)
        profileButton.tintColor = .black
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.addSubview(profileButton)
        
        NSLayoutConstraint.activate([
            messButton.leadingAnchor.constraint(equalTo: bottomPanel.leadingAnchor, constant: 20),
            messButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            messButton.widthAnchor.constraint(equalToConstant: 150),
            messButton.heightAnchor.constraint(equalToConstant: 40),
            
            profileButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -20),
            profileButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 150),
            profileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupAssetsTableView() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        assetsTableView = UITableView()
        assetsTableView.translatesAutoresizingMaskIntoConstraints = false
        assetsTableView.backgroundColor = .clear
        assetsTableView.separatorStyle = .none
        assetsTableView.dataSource = self
        assetsTableView.delegate = self
        
        assetsTableView.register(AssetTableViewCell.self, forCellReuseIdentifier: "AssetCell")
        
        container.addSubview(assetsTableView)
        
        NSLayoutConstraint.activate([
            assetsTableView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            assetsTableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            assetsTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            assetsTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func MessegerButtonTapped() {
        let newVC = DayViewController()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func ProfileButtonTapped() {
        let newVC = ProfileViewController()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func addAsset() {
        let alert = UIAlertController(title: "Добавить актив", message: "Введите валюту (RUB или USD) и количество", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Валюта (RUB или USD)"
            textField.autocapitalizationType = .allCharacters
        }
        alert.addTextField { textField in
            textField.placeholder = "Количество"
            textField.keyboardType = .decimalPad
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let currencyInput = alert.textFields?[0].text,
                  let amountInput = alert.textFields?[1].text,
                  !currencyInput.isEmpty,
                  let amount = Double(amountInput) else {
                return
            }
            let currency = currencyInput.uppercased()
            print("Добавлено \(amountInput) \(currency)")
            
            if let index = self.assets.firstIndex(where: { $0.currency == currency }) {
                var currentAsset = self.assets[index]
                currentAsset.amount += amount
                self.assets[index] = currentAsset
            } else {
                self.assets.append(Asset(currency: currency, amount: amount))
            }
            self.assetsTableView.reloadData()
            self.saveAssets() // Сохранить активы после добавления
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource & Delegate методы
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as? AssetTableViewCell else {
            return UITableViewCell()
        }

        let asset = assets[indexPath.row]
        cell.assetLabel.text = "\(asset.currency): \(asset.amount)"
        cell.selectionStyle = .none // Отключаем стандартное выделение
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAsset = assets[indexPath.row]

        // Создаем новый контроллер для отображения деталей актива
        let detailVC = AssetDetailViewController()
        detailVC.currency = selectedAsset.currency
        detailVC.amount = selectedAsset.amount
        
        // Устанавливаем делегат для обновления активов
        detailVC.delegate = self
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Добавляем анимацию при отображении ячейки
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        // Изменяем фон ячейки при нажатии
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        // Возвращаем фон ячейки при отпускании
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
    }
}

// MARK: - AssetDetailViewControllerDelegate
extension MenuViewController: AssetDetailViewControllerDelegate {
    func didUpdateAsset(currency: String, amount: Double) {
        if let index = assets.firstIndex(where: { $0.currency == currency }) {
            assets[index].amount = amount
        }
        assetsTableView.reloadData()
        saveAssets() // Сохранить активы после обновления
    }
    
    func didDeleteAsset(currency: String) {
        assets.removeAll { $0.currency == currency }
        assetsTableView.reloadData()
        saveAssets() // Сохранить активы после удаления
    }
}

// MARK: - UserDefaults Methods
extension MenuViewController {
    private func saveAssets() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(assets) {
            UserDefaults.standard.set(encoded, forKey: "assets")
        }
    }

    private func loadAssets() {
        if let savedAssetsData = UserDefaults.standard.object(forKey: "assets") as? Data {
            let decoder = JSONDecoder()
            if let loadedAssets = try? decoder.decode([Asset].self, from: savedAssetsData) {
                assets = loadedAssets
            }
        }
    }
}
