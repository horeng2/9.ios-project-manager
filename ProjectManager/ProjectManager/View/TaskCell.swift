//
//  ToDocell.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/03.
//

import UIKit

class TaskCell: UITableViewCell {
    let taskCellViewModel = TaskCellViewModel()
    private let cellStackView = UIStackView()
    let titleLable = UILabel()
    private let explanationLabel = UILabel()
    private let deadLineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
          style: style,
          reuseIdentifier: reuseIdentifier
        )
        contentView.addSubview(cellStackView)
        setupCellStackView()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellStackView() {
        cellStackView.addArrangedSubview(titleLable)
        cellStackView.addArrangedSubview(explanationLabel)
        cellStackView.addArrangedSubview(deadLineLabel)
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.isLayoutMarginsRelativeArrangement = true
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
    
    func configure(with indexPath: Int) {
        titleLable.text = taskCellViewModel.cellData(indexPath: indexPath).title
        explanationLabel.text = taskCellViewModel.cellData(indexPath: indexPath).explanation
        deadLineLabel.text = taskCellViewModel.cellData(indexPath: indexPath).localizedDeadline
    }
}
