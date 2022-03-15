//
//  ToDoPosition.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/04.
//

import Foundation

enum ToDoPosition: CaseIterable {
    case ToDo
    case Doing
    case Done
    
    var name: String {
        return "\(self)"
    }
    var moveButtonName: String {
        return "Move to \(self)"
    }
}
