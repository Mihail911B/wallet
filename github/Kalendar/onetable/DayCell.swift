//
//  DayCell.swift
//  github
//
//  Created by М Й on 01.03.2025.
//

import UIKit

class DayCell: UITableViewCell {
    
    // Контейнер, внутри которого будет зеленая обводка и округление (овальная форма)
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear  // можно задать иной фон, если требуется
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    
    // Метка для отображения текста (например, название дня)
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Делаем фон ячейки прозрачным, чтобы отступы были видны
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Добавляем containerView в contentView с отступами:
        // слева - 10, справа - 10, сверху и снизу - 5 (для разделения ячеек)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        // Добавляем dayLabel внутрь containerView - отступ слева 10 (также справа 10)
        containerView.addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обеспечиваем, чтобы размеры контейнера были актуальными
        containerView.layoutIfNeeded()
        // Скругляем containerView до овала: радиус равен половине его высоты
        containerView.layer.cornerRadius = containerView.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


