//
//  DetailCell.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

// Кастомная ячейка для детальной информации
// В каждой ячейке DetailCell содержится контейнер с зеленой обводкой и отступом 10 от левого к
import UIKit

class DetailCell: UITableViewCell {
    
    // Неподвижная метка для времени (не редактируется)
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.backgroundColor = .black
        label.text = "00:00" // значения устанавливаются из data source
        return label
    }()
    
    // Метка для дополнительного текста, который пользователь может задать
    let extraLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    // Кнопка для очистки дополнительного текста
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Системная иконка для очистки, можно изменить на нужную
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // Кнопка для дублирования содержимого ячейки в следующую
    let duplicateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Системная иконка "doc.on.doc" показывает дублирование
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // Closure для обработки нажатий на кнопки
    var onClearButtonTapped: (() -> Void)?
    var onDuplicateButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        contentView.backgroundColor = .black
        
        // Добавляем все элементы в contentView.
        contentView.addSubview(timeLabel)
        contentView.addSubview(extraLabel)
        contentView.addSubview(duplicateButton)
        contentView.addSubview(clearButton)
        
        // Расположение элементов:
        // timeLabel – закреплена слева с отступом 20, фиксированная ширина (например, 60)
        // extraLabel – справа от timeLabel, занимает оставшееся пространство до duplicateButton с промежутком 10
        // duplicateButton – справа от extraLabel, фиксированный размер 30x30, с отступом 10 от clearButton
        // clearButton – закреплена справа с отступом 20, размер 30x30
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 60),
            
            extraLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            extraLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            duplicateButton.leadingAnchor.constraint(equalTo: extraLabel.trailingAnchor, constant: 10),
            duplicateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            duplicateButton.widthAnchor.constraint(equalToConstant: 30),
            duplicateButton.heightAnchor.constraint(equalToConstant: 30),
            
            clearButton.leadingAnchor.constraint(equalTo: duplicateButton.trailingAnchor, constant: 10),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clearButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 30),
            clearButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Действия для кнопок:
        clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        duplicateButton.addTarget(self, action: #selector(didTapDuplicateButton), for: .touchUpInside)
    }
    
    @objc private func didTapClearButton() {
        onClearButtonTapped?()
    }
    
    @objc private func didTapDuplicateButton() {
        onDuplicateButtonTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
