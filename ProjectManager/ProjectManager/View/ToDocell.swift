//
//  ToDocell.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/03.
//

import UIKit

class ToDocell: UITableViewCell {
    private let cellStackView = UIStackView()
    private let titleLable = UILabel()
    private let explanationLabel = UILabel()
    private let deadLineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
          style: style,
          reuseIdentifier: reuseIdentifier
        )
        contentView.addSubview(cellStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellStackView() {
        cellStackView.addArrangedSubview(titleLable)
        cellStackView.addArrangedSubview(explanationLabel)
        cellStackView.addArrangedSubview(deadLineLabel)
    }
    
    func setupCellConstraints() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
