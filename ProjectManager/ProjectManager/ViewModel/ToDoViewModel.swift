//
//  TaskCellViewModel.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/04.
//

import Foundation

class ToDoViewModel {
    private let dataManager = TestDataManager()
    var todoOnUpdated: (() -> Void) = {}
    var taskCount = [ToDoPosition: Int]()
    var todos = [ToDoInfomation]() {
        didSet {
            todos = todos.sorted { $0.deadline > $1.deadline }
            updateTaskCount()
            todoOnUpdated()
        }
    }
        
    func save(with todo: ToDoInfomation) {
        dataManager.save(with: todo)
        self.reload()
    }
    
    func delete(with todo: ToDoInfomation) {
        dataManager.delete(with: todo)
        self.reload()
    }
    
    func changePosition(
        from berforePosition: ToDoPosition,
        to afterPosition: ToDoPosition,
        currentIndexPath: Int
    ) {
        let beforePositionList = todos.filter{ $0.position == berforePosition }
        let targetId = beforePositionList[currentIndexPath].id
        dataManager.changePosition(
            to: afterPosition,
            target: targetId
        )
        self.reload()
    }
    
    func reload() {
        dataManager.fetch { [weak self] todoList in
            guard let self = self else {
                return
            }
            self.todos = todoList
        }
        
        var taskCount = [ToDoPosition: Int]()
        ToDoPosition.allCases.forEach{ position in
            taskCount.updateValue(
                todos.filter{$0.position == position}.count,
                forKey: position
            )
        }
    }
    
    @discardableResult
    func updateTaskCount() -> [ToDoPosition: Int]{
        let todoCount = todos.filter{ $0.position == .ToDo}.count
        let doingCount = todos.filter{ $0.position == .Doing}.count
        let doneCount = todos.filter{ $0.position == .Done}.count
        taskCount.updateValue(todoCount, forKey: .ToDo)
        taskCount.updateValue(doingCount, forKey: .Doing)
        taskCount.updateValue(doneCount, forKey: .Done)
        
        return self.taskCount
    }
}
