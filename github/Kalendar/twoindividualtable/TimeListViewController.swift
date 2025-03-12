//
//  TimeListViewController.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

import UIKit

class TimeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    // Массив строк с временем от 00:00 до 24:00. Если хотите включить 24:00, используем цикл от 0 до 24 включительно.
    private var times: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Время дня"
        
        generateTimes()
        setupTableView()
    }
    
    private func generateTimes() {
        // Заполняем массив времени от 00:00 до 24:00 (всего 25 значений)
        for hour in 0...24 {
            // Форматируем строку с ведущим нулем, если нужно
            let timeStr = String(format: "%02d:00", hour)
            times.append(timeStr)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine  // Если нужны стандартные разделительные линии
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрируем DetailCell
        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        // Выставляем время для каждой ячейки
        cell.timeLabel.text = times[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Например, снимаем выделение при нажатии
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
