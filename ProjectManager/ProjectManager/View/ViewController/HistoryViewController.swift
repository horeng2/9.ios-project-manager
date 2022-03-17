//
//  ViewController.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/16.
//

import UIKit

enum HistorySection: CaseIterable {
    case add
    case move
    case delete
    
    var title: String {
        switch self {
        case .add:
            return "☑️ 추가했어요"
        case .move:
            return "☑️ 이동했어요"
        case .delete:
            return "☑️ 삭제했어요"
        }
    }
}

protocol HistoryViewDelegate: AnyObject {
    func loadTaskLog() -> [TaskLog]
}

class HistoryViewController: UIViewController {
    var delegate: HistoryViewDelegate!
    private var addTaskLog = [TaskLog]()
    private var moveTaskLog = [TaskLog]()
    private var deleteTaskLog = [TaskLog]()
    private let historyTableView = UITableView()
    private let historySection: [String] = {
        var section: [String] = []
        HistorySection.allCases.forEach{
            section.append($0.title)
        }
        return section
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTaskLog()
        view.addSubview(historyTableView)
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(
            HistoryCell.self,
            forCellReuseIdentifier: "historyCell"
        )
        setupNavigation()
        setupConstraint()
    }
    
    private func setupTaskLog() {
        let taskLog = delegate.loadTaskLog()
        addTaskLog = taskLog.filter{$0.logSection == .add}
        moveTaskLog = taskLog.filter{$0.logSection == .move}
        deleteTaskLog = taskLog.filter{$0.logSection == .delete}
    }

    private func setupNavigation() {
        navigationItem.title = "History"
        let rightButton = UIBarButtonItem(
        title: "Done",
        style: .done,
        target: self,
        action: #selector(dismissHistoryView)
        )
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    @objc
    private func dismissHistoryView() {
        self.dismiss(animated: true)
    }

    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HistorySection.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if section == 0 {
            return addTaskLog.count
        } else if section == 1 {
            return moveTaskLog.count
        } else if section == 2 {
            return deleteTaskLog.count
        } else {
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "historyCell",
            for: indexPath
        ) as? HistoryCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.configure(with: addTaskLog[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            cell.configure(with: moveTaskLog[indexPath.row])
            return cell
        } else if indexPath.section == 2 {
            cell.configure(with: deleteTaskLog[indexPath.row])
            return cell
        } else {
            return HistoryCell()
        }
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return historySection[section]
    }
}
