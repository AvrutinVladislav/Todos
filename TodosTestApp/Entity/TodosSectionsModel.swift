//
//  TodosSectionsModel.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 27.08.2024.
//

import Foundation

struct TodosSectionsModel: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}
