//
//  taskTableView.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/15.
//

import UIKit

class TaskTableView: UITableView {
    var position: ToDoPosition?
    
    init(position: ToDoPosition) {
        super.init(frame: .zero, style: .plain)
        self.position = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
