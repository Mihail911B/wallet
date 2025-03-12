//
//  KalendViewController.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

// Контроллер со списком дней
import UIKit
class DayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private var days: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Дни недели"
        setupTableView()
        generateDays()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.rowHeight = 60  // Фиксированная высота для выразительного эффекта
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрируем кастомную ячейку DayCell
        tableView.register(DayCell.self, forCellReuseIdentifier: "DayCell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func generateDays() {
        let formatter = DateFormatter()
        // Формат, например, "Понедельник, 04 мая"
        formatter.dateFormat = "EEEE, dd MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        let calendar = Calendar.current
        
        days.removeAll()
        // Генерируем 30 последовательных дней (при необходимости можно заменить на 7)
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: Date()) {
                let dayString = formatter.string(from: date)
                days.append(dayString.capitalized)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.dayLabel.text = days[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // При нажатии переходим на экран с детальной информацией дня
        let detailVC = DayDetailViewController()
        detailVC.selectedDay = days[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
