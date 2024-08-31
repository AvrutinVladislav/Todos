//
//  TodosModel.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 26.08.2024.
//

import Foundation

struct Todo: Codable {
    var todoId: Int
    var userId: Int
    var isCompleted: Bool
    var todo: String 
    
    enum CodingKeys: String, CodingKey {
        case todoId = "id"
        case userId
        case isCompleted = "completed"
        case todo
    }
    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(todoId, forKey: .todoId)
//        try container.encode(userId, forKey: .userId)
//        try container.encode(isCompleted, forKey: .isCompleted)
//        try container.encode(todo, forKey: .todo)
//    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.todoId = try container.decode(Int.self, forKey: .todoId)
//        self.userId = try container.decode(Int.self, forKey: .userId)
//        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
//        self.todo = try container.decode(String.self, forKey: .todo)
//    }
}
