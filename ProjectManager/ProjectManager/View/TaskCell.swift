//
//  ToDocell.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/03.
//

import UIKit

class TaskCell: UITableViewCell {
    private let cellStackView = UIStackView()
    var position: ToDoPosition? = nil
    let titleLabel = UILabel()
    private let discriptionLabel = UILabel()
    private let deadLineLabel = UILabel()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(discriptionLabel)
        cellStackView.addArrangedSubview(deadLineLabel)
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.spacing = 5
    }
    
    private func setupCellConstraints() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            cellStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            cellStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 15
            ),
            cellStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -15
            )
        ])
    }
    
    private func setupCellContent() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        discriptionLabel.font = .preferredFont(forTextStyle: .body)
        discriptionLabel.textColor = .gray
        discriptionLabel.numberOfLines = 3
    }
    
    func configure(with todo: ToDoInfomation) {
        position = todo.position
        titleLabel.text = todo.title
        discriptionLabel.text = todo.discription
        deadLineLabel.text = todo.localizedDateString
        if todo.position != .Done && todo.deadline < Date().timeIntervalSince1970 {
            deadLineLabel.textColor = .red
        }
    }
    
    func getIndexPath() -> IndexPath? {
        let superView = self.superview as? UITableView
        let indexPath = superView?.indexPath(for: self)
        return indexPath
    }
}
