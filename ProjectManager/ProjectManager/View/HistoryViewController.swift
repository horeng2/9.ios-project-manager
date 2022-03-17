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

class HistoryViewController: UIViewController {
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
        view.backgroundColor = .white
        view.addSubview(historyTableView)
        setupNavigation()
        setupConstraint()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: "historyCell"
        )
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
    
    @objc
    private func dismissHistoryView() {
        self.dismiss(animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HistorySection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let todo = ToDoInfomation(id: UUID(), title: "fsdfs", discription: "dsfsfsfd", deadline: 2234234234, position: .ToDo)
        cell.configure(with: todo)
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return historySection[section]
    }
}
