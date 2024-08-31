//
//  TodoItem+CoreDataClass.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 29.08.2024.
//
//

import Foundation
import CoreData

public class TodoItem: NSManagedObject {}

extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }
    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var todo: String?
    @NSManaged public var date: Date
}

extension TodoItem : Identifiable {}
