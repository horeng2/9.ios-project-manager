//
//  ToDoRepository.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/04.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class ToDoRepository {
    let db = Firestore.firestore()
    private var todos = [UUID : ToDoInfomation]()    //데이터베이스 역할(엔티티)
    
    func save(with todo: ToDoInfomation) {
        if todos.contains(where: { $0.key == todo.id }) {
            self.update(with: todo)
        } else {
            //            todos[todo.id] = todo
            db.collection("Todos").document("\(todo.id)").setData(todo.data())
        }
    }
    
    func delete(with todo: ToDoInfomation) {
        //        todos.removeValue(forKey: todo.id)
        db.collection("Todos").document("\(todo.id)").delete()
    }
    
    private func update(with todo: ToDoInfomation) {
        //        todos.updateValue(todo, forKey: todo.id)
        db.collection("Todos").document("\(todo.id)").updateData(todo.data())
    }
    
    func fetch(onCompleted: @escaping ([ToDoInfomation]) -> Void) {
        db.collection("Todos").getDocuments { querySnapshot, error in
            var todos: [[String:Any]] = []
            guard let doc = querySnapshot?.documents else {
                return
            }
            for index in 0..<doc.count {
                let documentData = doc[index].data()
                todos.append(documentData)
            }
        }
        
        //        let todoData = todos.map { $0.value }
        //        onCompleted(todoData)
    }
}
