////
////  ToDoViewController.swift
////  ProjectManager
////
////  Created by 서녕 on 2022/03/02.
////
//
//import UIKit
//
//class ToDoViewController: UIViewController {
//    let toDoViewModel = ToDoViewModel()
//    let toDoTableView = UITableView()
//    lazy var dataSource = TaskDataSource()
//    let editViewController = EditViewController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupToDoTableView()
//        setupConstraints()
//        editViewController.delegate = self
//    }
//
//    private func setupToDoTableView() {
//        view.addSubview(toDoTableView)
//        toDoTableView.dataSource = dataSource
//        toDoTableView.register(
//            TaskCell.self,
//            forCellReuseIdentifier: "TaskCell"
//        )
//    }
//
//    private func setupConstraints() {
//        let safeArea = view.safeAreaLayoutGuide
//        toDoTableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            toDoTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            toDoTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
//            toDoTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//            toDoTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
//        ])
//    }
//
//}
//
//extension ToDoViewController: EditViewDelegate {
//    func editViewWillDismiss() {
//        toDoTableView.reloadData()
//    }
//
//
//}
//
