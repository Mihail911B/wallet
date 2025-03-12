//
//  AssetTableViewCell.swift
//  github
//
//  Created by М Й on 02.03.2025.
//

import UIKit

class AssetTableViewCell: UITableViewCell {
    
    // Контейнер для отображения содержимого ячейки
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black  // фон ячейки теперь черный
        view.layer.cornerRadius = 10     // скругленные углы
        view.layer.borderColor = UIColor.green.cgColor  // зеленая обводка
        view.layer.borderWidth = 2       // ширина обводки
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Метка для отображения информации об активе
    let assetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Отключаем режим выделения ячейки
        self.selectionStyle = .none
        
        // Фон ячейки и контента теперь прозрачный, чтобы был виден контейнер
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Добавляем контейнер в contentView
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // Добавляем метку внутрь контейнера
        containerView.addSubview(assetLabel)
        NSLayoutConstraint.activate([
            assetLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            assetLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            assetLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            assetLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
