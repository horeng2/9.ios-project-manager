//
//  ProjectManager - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var todoViewModel = ToDoViewModel()
    private let taskStackView = UIStackView()
    private let toDoTableView = TaskTableView(position: .ToDo)
    private let doingTableView = TaskTableView(position: .Doing)
    private let doneTableView = TaskTableView(position: .Done)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTaskStackView()
        setupConstraint()
        setupTableView()
        tableViewRegister()
        todoViewModel.todoOnUpdated = { [weak self] in
            self?.toDoTableView.reloadData()
            self?.doingTableView.reloadData()
            self?.doneTableView.reloadData()
        }
        todoViewModel.reload()
    }
    
    private func setupNavigation() {
        navigationItem.title = "Project Manager"
        let addButtonImage = UIImage(systemName: "plus")
        let leftButton = UIBarButtonItem(
            title: "History",
            style: .done,
            target: self,
            action: #selector(showHistoryView)
        )
        let rightButton = UIBarButtonItem(
            image: addButtonImage,
            style: .done,
            target: self,
            action: #selector(showEditView)
        )
        navigationItem.setLeftBarButton(
            leftButton,
            animated: false
        )
        navigationItem.setRightBarButton(
            rightButton,
            animated: false
        )
    }
    
    private func setupTaskStackView() {
        view.addSubview(taskStackView)
        taskStackView.addArrangedSubview(toDoTableView)
        taskStackView.addArrangedSubview(doingTableView)
        taskStackView.addArrangedSubview(doneTableView)
        taskStackView.axis = .horizontal
        taskStackView.distribution = .fillEqually
        taskStackView.backgroundColor = .lightGray
        taskStackView.spacing = 10
    }
    
    private func setupConstraint() {
        taskStackView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            taskStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            taskStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            taskStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            taskStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        toDoTableView.dataSource = self
        doingTableView.dataSource = self
        doneTableView.dataSource = self
        toDoTableView.delegate = self
        doingTableView.delegate = self
        doneTableView.delegate = self
        toDoTableView.backgroundColor = .systemGray6
        doingTableView.backgroundColor = .systemGray6
        doneTableView.backgroundColor = .systemGray6
    }
    
    private func tableViewRegister() {
        toDoTableView.register(
            TaskTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: ViewIdentifier.todoHeaderId
        )
        doingTableView.register(
            TaskTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: ViewIdentifier.doingHeaderId
        )
        doneTableView.register(
            TaskTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: ViewIdentifier.doneHeaderId
        )
        toDoTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: ViewIdentifier.todoCellId
        )
        doingTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: ViewIdentifier.doingCellId
        )
        doneTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: ViewIdentifier.doneCellId
        )
    }
    
    @objc
    func showHistoryView() {
        let historyView = HistoryViewController()
        historyView.delegate = todoViewModel
        let historyModal = UINavigationController(rootViewController: historyView)
        historyModal.modalPresentationStyle = .automatic
        self.present(historyModal, animated: true)
    }

    @objc
    private func showEditView() {
        let editView = EditViewController()
        editView.delegate = self
        let modalView = UINavigationController(rootViewController: editView)
        modalView.modalPresentationStyle = .automatic
        self.present(modalView, animated: true)
    }
    
    private func setupLongPressRecognizer(cell: TaskCell) {
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(setupPopover(sender:))
        )
        cell.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func setupPopover(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            guard let cell = sender.view as? TaskCell,
                  let position = cell.position,
                  let indexPath = cell.getIndexPath() else {
                        return
                    }
            
            let popoverList = ToDoPosition.allCases.filter{ $0 != position }
            guard let firstSelect = popoverList.first,
                  let secondSelect = popoverList.last else {
                      return
                  }
            
            self.showPopover(
                cell: cell,
                firstSelectTitle: firstSelect.moveButtonName,
                secondSelectTitle: secondSelect.moveButtonName
            ) { _ in
                self.todoViewModel.changePosition(
                    from: position,
                    to: firstSelect,
                    currentIndexPath: indexPath.row
            )} secoundHandler: { _ in
                self.todoViewModel.changePosition(
                    from: position,
                    to: secondSelect,
                    currentIndexPath: indexPath.row
            )}
        }
    }
    
    private func showPopover(
        cell: TaskCell,
        firstSelectTitle: String,
        secondSelectTitle: String,
        firstHandler: @escaping (UIAlertAction) -> Void,
        secoundHandler: @escaping (UIAlertAction) -> Void
    ) {
        let firstAction = UIAlertAction(
            title: firstSelectTitle,
            style: .default,
            handler: firstHandler
        )
        let secondAction = UIAlertAction(
            title: secondSelectTitle,
            style: .default,
            handler: secoundHandler
        )
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let popover = alert.popoverPresentationController
        popover?.sourceView = cell
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        self.present(alert, animated: true)
    }
}

extension MainViewController: EditViewDelegate {
    func editViewDidDismiss(todo: ToDoInfomation) {
        todoViewModel.save(with: todo)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewPosition = tableView.asTaskTableView().position
        let taskCount = todoViewModel.todos.filter{ $0.position == tableViewPosition}.count
        let headerId: String
        
        switch tableViewPosition {
        case .ToDo:
            headerId = ViewIdentifier.todoHeaderId
        case .Doing:
            headerId = ViewIdentifier.doingHeaderId
        case .Done:
            headerId = ViewIdentifier.doneHeaderId
        }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? TaskTableViewHeader else {
            return UIView()
        }
        headerView.configure(title: tableViewPosition.name, count: taskCount)
        return headerView
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let tableViewPosition = tableView.asTaskTableView().position
        return todoViewModel.taskCount[tableViewPosition] ?? .zero
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellIdentifier: String
        
        switch tableView.asTaskTableView().position {
        case .ToDo:
            cellIdentifier = ViewIdentifier.todoCellId
        case .Doing:
            cellIdentifier = ViewIdentifier.doingCellId
        case .Done:
            cellIdentifier = ViewIdentifier.doneCellId
        }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as? TaskCell else {
            return UITableViewCell()
        }
        
        let todo = todoViewModel.todos[indexPath.row]
        cell.configure(with: todo)
        
        setupLongPressRecognizer(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo: ToDoInfomation
        if tableView == toDoTableView {
            todo = todoViewModel.todos.filter{ $0.position == .ToDo }[indexPath.row]
        } else if tableView == doingTableView {
            todo = todoViewModel.todos.filter { $0.position == .Doing }[indexPath.row]
        } else {
            todo = todoViewModel.todos.filter { $0.position == .Done }[indexPath.row]
        }
        
        let editView = EditViewController()
        editView.configure(todo: todo)
        editView.delegate = self
        let modalView = UINavigationController(rootViewController: editView)
        modalView.modalPresentationStyle = .automatic
        self.present(modalView, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteTarget = todoViewModel.todos[indexPath.row]
        let delete = UIContextualAction(
            style: .normal,
            title: "Delete"
        ) { _, _, _ in
            self.todoViewModel.delete(with: deleteTarget)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension UITableView {
    func asTaskTableView() -> TaskTableView {
        guard let taskTableView = self as? TaskTableView else {
            return TaskTableView()
        }
        return taskTableView
    }
}
