//
//  HistoryCell.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/17.
//

import UIKit

class HistoryCell: UITableViewCell {
    let historyStackView = UIStackView()
    let titleLabel = UILabel()
    let editTimeLabel = UILabel()
    let beforPositionLabel = UILabel()
    let afterPositionLabel = UILabel()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
          style: style,
          reuseIdentifier: reuseIdentifier
        )
        setupCellStackView()
        setupCellConstraints()
        setupCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellStackView() {
        contentView.addSubview(historyStackView)
        historyStackView.axis = .vertical
        historyStackView.addArrangedSubview(titleLabel)
        historyStackView.addArrangedSubview(editTimeLabel)
        historyStackView.addArrangedSubview(beforPositionLabel)
        historyStackView.addArrangedSubview(afterPositionLabel)
    }
    
    func setupCellConstraints() {
        historyStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            historyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            historyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            historyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func setupCellContent() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        editTimeLabel.font = .preferredFont(forTextStyle: .headline)
        beforPositionLabel.font = .preferredFont(forTextStyle: .headline)
        beforPositionLabel.textColor = .gray
        afterPositionLabel.font = .preferredFont(forTextStyle: .headline)
        afterPositionLabel.textColor = .blue
    }
}
