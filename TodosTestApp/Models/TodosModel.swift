//
//  TodosModel.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 26.08.2024.
//

import Foundation

struct TodosModel: Codable {
    var todoId: String
    var userId: String
    var isCompleted: Bool = false
    var todo: String = "sfsdfsdfsffsdfdghrtghrtewgwgwgewrgewrgwergewrg sdfg sfg sdfgsdfg sd dsfg sdfg sdfg sdf sdfg sdfg sdfg sdfg sdf "
    
    enum codingKeys: String, CodingKey {
        case todoId = "id"
        case userId
        case isCompleted = "completed"
        case todo
    }
}
