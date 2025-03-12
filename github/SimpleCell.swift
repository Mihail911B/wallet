//
//  GoalCell.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

import UIKit

// Кастомная ячейка с зеленой рамкой и отступом 10 от левого края
class SimpleCell: UITableViewCell {
    
    // Контейнер для оформления ячейки с рамкой
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // Фон можно задать, например, белым, чтобы рамка хорошо выделялась
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        // Если нужно округлить углы, можно установить значение cornerRadius
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // Метка для отображения номера ячейки
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Делаем фон ячейки прозрачным, чтобы отступы были видны
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Добавляем контейнер и задаем отступы: слева 10, сверху и снизу по 5
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        // Добавляем метку в контейнер с отступом 10 от левого края
        containerView.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            cellLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Контроллер с таблицей из 24 ячеек
class SimpleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SimpleCell.self, forCellReuseIdentifier: "SimpleCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath) as! SimpleCell
        // Отображаем номер ячейки
        cell.cellLabel.text = "Ячейка \(indexPath.row + 1)"
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Обработка нажатия на ячейку (при необходимости)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
