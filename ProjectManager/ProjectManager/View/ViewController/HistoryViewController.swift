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
    private var taskLog: [TaskLog] = []
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
        self.taskLog = delegate.loadTaskLog()
        view.backgroundColor = .white
        view.addSubview(historyTableView)
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: "historyCell"
        )
        setupNavigation()
        setupConstraint()
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
        let addCount = taskLog.filter{$0.logSection == .add}.count
        let moveCount = taskLog.filter{$0.logSection == .move}.count
        let deleteCount = taskLog.filter{$0.logSection == .delete}.count
        
        if section == 0 {
            return addCount
        } else if section == 1 {
            return moveCount
        } else if section == 2 {
            return deleteCount
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
        ) as? TaskCell else {
            return UITableViewCell()
        }
//      테스트용
//        let todo = ToDoInfomation(id: UUID(), title: "fsdfs", discription: "dsfsfsfd", deadline: 2234234234, position: .ToDo)
//        cell.configure(with: todo)
//
        return cell
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
