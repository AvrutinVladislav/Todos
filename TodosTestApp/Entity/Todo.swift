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
    
}
