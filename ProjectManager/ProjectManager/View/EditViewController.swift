//
//  EditViewController.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/03.
//

import UIKit

class EditViewController: UIViewController {
    let toDoViewModel = ToDoViewModel()
    private let editStackView = UIStackView()
    private let titleTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let contentTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupStackView()
        setupStackViewConstraints()
        setupChildViewConstraints()
        setuptitleTextField()
        setupDatePicker()
        view.backgroundColor = .white
    }
    
    func setupNavigation() {
        navigationItem.title = "TODO"
        let leftButton = UIBarButtonItem(
        title: "Cancel",
        style: .done,
        target: self,
        action: #selector(touchUpCancelButton)
        )
        let rightButton = UIBarButtonItem(
        title: "Done",
        style: .done,
        target: self,
        action: #selector(touchUpDoneButton)
        )
        navigationItem.setLeftBarButton(leftButton, animated: false)
        navigationItem.setRightBarButton(rightButton, animated: false)
    }

    func setupStackView() {
        view.addSubview(editStackView)
        editStackView.addArrangedSubview(titleTextField)
        editStackView.addArrangedSubview(datePicker)
        editStackView.addArrangedSubview(contentTextView)
        
        editStackView.axis = .vertical
        editStackView.distribution = .fill
        editStackView.spacing = 20
    }
    
    func setupStackViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        editStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            editStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            editStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            editStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        ])
    }
    
    func setupChildViewConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func setuptitleTextField() {
        titleTextField.placeholder = "Title"
    }
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = NSTimeZone.local
    }
    
    @objc func touchUpCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func touchUpDoneButton() {
        let uuid = UUID()
        let title = titleTextField.text ?? ""
        let date = datePicker.date.timeIntervalSince1970
        let explanation = contentTextView.text ?? ""
        let taskInfomation = TaskInfomation(
            uuid: uuid,
            title: title,
            explanation: explanation,
            deadline: date
        )
        toDoViewModel.saveData(task: taskInfomation)
        self.dismiss(animated: true)
    }
}
