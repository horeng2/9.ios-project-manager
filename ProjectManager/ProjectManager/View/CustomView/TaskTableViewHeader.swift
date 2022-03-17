//
//  TableViewHeader.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/14.
//

import UIKit

final class TaskTableViewHeader: UITableViewHeaderFooterView {
    private let headerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let spacingView = UIView()
  
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViews()
        setupHeaderStackView()
        setupHeaderLabels()
        setupLayout()
    }
    
    convenience init(title: String, count: Int) {
        self.init()
        self.titleLabel.text = title
        self.countLabel.text = "\(count)"
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(headerStackView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(countLabel)
        headerStackView.addArrangedSubview(spacingView)
    }
    
    private func setupHeaderStackView() {
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        headerStackView.spacing = 10
    }
    
    private func setupHeaderLabels() {
        spacingView.setContentHuggingPriority(
            .fittingSizeLevel,
            for: .horizontal
        )
        spacingView.setContentCompressionResistancePriority(
            .fittingSizeLevel,
            for: .horizontal)

        titleLabel.sizeToFit()
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        countLabel.sizeToFit()
        countLabel.font = .preferredFont(forTextStyle: .callout)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .black
        countLabel.textColor = .white
        countLabel.layer.masksToBounds = true
        countLabel.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        countLabel.layer.cornerRadius = 30/2
    }

    private func setupLayout() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            headerStackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 10
            ),
            countLabel.topAnchor.constraint(
                equalTo: headerStackView.topAnchor,
                constant: 10
            ),
            countLabel.bottomAnchor.constraint(
                equalTo: headerStackView.bottomAnchor,
                constant: -10
            ),
            headerStackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: 10
            ),
            countLabel.widthAnchor.constraint(equalTo: countLabel.heightAnchor)
        ])
    }
    
    func configure(title: String, count: Int) {
        self.titleLabel.text = title
        self.countLabel.text = "\(count)"
    }
}
