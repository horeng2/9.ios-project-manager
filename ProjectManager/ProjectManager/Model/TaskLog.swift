//
//  TaskLog.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/17.
//

import Foundation

struct TaskLog {
    let logSection: HistorySection
    let title: String
    let editTime: Double
    var beforePosition: ToDoPosition?
    var afterPosition: ToDoPosition?
    
    var localizedEditTimeString: String {
        return DateFormatter().localizedDateString(from: editTime)
    }
}
