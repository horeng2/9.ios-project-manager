//
//  ToDoInfomation.swift
//  ProjectManager
//
//  Created by 서녕 on 2022/03/02.
//

import Foundation

struct ToDoInfomation {
    var id: UUID
    let title: String
    let discription: String
    let deadline: Double
    var position: ToDoPosition
    var localizedDateString: String {
        return DateFormatter().localizedDateString(from: deadline)
    }
}

extension ToDoInfomation {
    func data() -> [String:Any] {
        let data: [String:Any] = [
            "id": "\(self.id)",
            "title": self.title,
            "discription": self.discription,
            "deadline": self.deadline,
            "position": self.position.name,
            "localizedDateString": self.localizedDateString
        ]
        return data
    }
}
