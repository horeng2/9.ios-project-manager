//
//  HistoryCell.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/17.
//

import UIKit

final class HistoryCell: UITableViewCell {
    private let historyStackView = UIStackView()
    private let titleLabel = UILabel()
    private let editTimeLabel = UILabel()
    private let changedPositionLabel = UILabel()
    
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
    
    private func setupCellStackView() {
        contentView.addSubview(historyStackView)
        historyStackView.addArrangedSubview(editTimeLabel)
        historyStackView.addArrangedSubview(changedPositionLabel)
        historyStackView.addArrangedSubview(titleLabel)
        historyStackView.axis = .vertical
        historyStackView.distribution = .fillEqually
        historyStackView.spacing = 5
    }
    
    private func setupCellConstraints() {
        historyStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20
            ),
            historyStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            ),
            historyStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),
            historyStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            )
        ])
    }
    
    private func setupCellContent() {
        editTimeLabel.font = .preferredFont(forTextStyle: .headline)
        changedPositionLabel.font = .preferredFont(forTextStyle: .headline)
        editTimeLabel.textColor = .systemBlue
        changedPositionLabel.textColor = .systemRed
        titleLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    func configure(with taskLog: TaskLog) {
        editTimeLabel.text = "실행일자: \(taskLog.localizedEditTimeString)"
        titleLabel.text = taskLog.title
        guard let beforePosition = taskLog.beforePosition?.name,
              let afterPosition = taskLog.afterPosition?.name else {
                  changedPositionLabel.isHidden = true
                  return
              }
        changedPositionLabel.text = beforePosition + " ➤ " + afterPosition
    }
}
