//
//  DayDetailViewController.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

// Контроллер детальной информации для выбранного дня.
// Для каждого дня создается отделённая таблица из кастомных ячеек (DetailCell),
// каждая из которых имеет зеленую обводку и отступ 10 от левого края.
import UIKit

class DayDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedDay: String?  // Переданное название дня ("Понедельник" и т.д.)
    private var tableView: UITableView!
    // Массив времени от "00:00" до "24:00" (25 значений)
    private var times: [String] = []
    // Массив для хранения дополнительного текста для каждой строки (персистентно сохраняется)
    private var extraTexts: [String] = []

    // Ключ для сохранения дополнительного текста, зависящий от выбранного дня
    private var extraTextsKey: String {
        return "extraTexts_\(selectedDay ?? "default")"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = selectedDay ?? "День"

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        setupTableView()
        generateTimes()
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.rowHeight = 60

        tableView.dataSource = self
        tableView.delegate = self

        // Регистрируем DetailCell
        tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func generateTimes() {
        // Генерируем массив времени от "00:00" до "24:00" (25 значений)
        times = (0...24).map { String(format: "%02d:00", $0) }
        loadExtraTexts()
        tableView.reloadData()
    }

    private func loadExtraTexts() {
        // Загружаем сохраненный массив из UserDefaults, если он соответствует количеству строк
        if let saved = UserDefaults.standard.array(forKey: extraTextsKey) as? [String], saved.count == times.count {
            extraTexts = saved
        } else {
            extraTexts = Array(repeating: "", count: times.count)
        }
    }

    private func saveExtraTexts() {
        UserDefaults.standard.set(extraTexts, forKey: extraTextsKey)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.timeLabel.text = times[indexPath.row]
        cell.extraLabel.text = extraTexts[indexPath.row]
        cell.selectionStyle = .none

        // Назначаем обработчик для кнопки "очистить" в ячейке
        cell.onClearButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.extraTexts[indexPath.row] = ""
            self.saveExtraTexts()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        // Назначаем обработчик для кнопки "дублировать" в ячейке
        cell.onDuplicateButtonTapped = { [weak self] in
            guard let self = self else { return }

            // Проверяем, что следующая ячейка существует
            if indexPath.row + 1 < self.extraTexts.count {
                // Дублируем текст из текущей ячейки в следующую
                self.extraTexts[indexPath.row + 1] = self.extraTexts[indexPath.row]
                self.saveExtraTexts()

                // Обновляем следующую ячейку
                tableView.reloadRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
            }
        }
        
        return cell
    }



    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Формируем alert для ввода дополнительного текста
        let alert = UIAlertController(title: "Добавьте текст", message: "Введите нужный текст для этой ячейки", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.extraTexts[indexPath.row]
            textField.placeholder = "Введите текст"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let newText = alert.textFields?.first?.text {
                self.extraTexts[indexPath.row] = newText
                self.saveExtraTexts()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
