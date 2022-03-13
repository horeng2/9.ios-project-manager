//
//  ProjectManager - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, UITableViewDelegate {
    private var todoViewModel = ToDoViewModel()
    private let taskStackView = UIStackView()
    private let toDoTableView = UITableView()
    private let doingTableView = UITableView()
    private let doneTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTaskStackView()
        setupConstraint()
        setupTableView()
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
        let rightButton = UIBarButtonItem(
            image: addButtonImage,
            style: .done,
            target: self,
            action: #selector(showEditView)
        )
        navigationItem.setRightBarButton(
            rightButton,
            animated: false
        )
    }
    
    private func setupTableView() {
        toDoTableView.dataSource = self
        doingTableView.dataSource = self
        doneTableView.dataSource = self
        toDoTableView.delegate = self
        doingTableView.delegate = self
        doneTableView.delegate = self
        toDoTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: "TodoCell"
        )
        doingTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: "DoingCell"
        )
        doneTableView.register(
            TaskCell.self,
            forCellReuseIdentifier: "DoneCell"
        )
        toDoTableView.backgroundColor = .systemGray6
        doingTableView.backgroundColor = .systemGray6
        doneTableView.backgroundColor = .systemGray6
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

    @objc private func showEditView() {
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

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if tableView == toDoTableView {
            return todoViewModel.todos.filter { $0.position == .ToDo }.count
        } else if tableView == doingTableView {
            return todoViewModel.todos.filter { $0.position == .Doing }.count
        } else {
            return todoViewModel.todos.filter { $0.position == .Done }.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellIdentifier: String
        if tableView == toDoTableView {
            cellIdentifier = "TodoCell"
        } else if tableView == doingTableView {
            cellIdentifier = "DoingCell"
        } else {
            cellIdentifier = "DoneCell"
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
