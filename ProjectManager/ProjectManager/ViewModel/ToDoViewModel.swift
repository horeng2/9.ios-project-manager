//
//  TaskCellViewModel.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/04.
//

import Foundation

class ToDoViewModel {
    private let dataManager = TestDataManager()
    private var taskLog: [TaskLog] = []
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
        addTaskLog(todo, in: .add, movedPosition: nil)
        self.reload()
    }
    
    func delete(with todo: ToDoInfomation) {
        dataManager.delete(with: todo)
        addTaskLog(todo, in: .delete, movedPosition: nil)
        self.reload()
    }
    
    func changePosition(
        from berforePosition: ToDoPosition,
        to afterPosition: ToDoPosition,
        currentIndexPath: Int
    ) {
        let beforePositionList = todos.filter{ $0.position == berforePosition }
        let todo = beforePositionList[currentIndexPath]
        dataManager.changePosition(
            to: afterPosition,
            target: todo.id
        )
        addTaskLog(
            todo,
            in: .move,
            movedPosition: (berforePosition, afterPosition)
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
    private func updateTaskCount() -> [ToDoPosition: Int]{
        let todoCount = todos.filter{ $0.position == .ToDo}.count
        let doingCount = todos.filter{ $0.position == .Doing}.count
        let doneCount = todos.filter{ $0.position == .Done}.count
        taskCount.updateValue(
            todoCount,
            forKey: .ToDo
        )
        taskCount.updateValue(
            doingCount,
            forKey: .Doing
        )
        taskCount.updateValue(
            doneCount,
            forKey: .Done
        )
        return self.taskCount
    }
    
    private func addTaskLog(
        _ todo: ToDoInfomation,
        in logSection: HistorySection,
        movedPosition: (ToDoPosition , ToDoPosition)?
    ) {
        let log = TaskLog(
            logSection: logSection,
            title: todo.title,
            editTime:  Date().timeIntervalSince1970,
            beforePosition: movedPosition?.0,
            afterPosition: movedPosition?.1
        )
        taskLog.append(log)
    }
}

extension ToDoViewModel: HistoryViewDelegate {
    func loadTaskLog() -> [TaskLog] {
        return self.taskLog
    }
}
