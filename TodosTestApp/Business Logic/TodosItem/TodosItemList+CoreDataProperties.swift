//
//  TodosItemList+CoreDataProperties.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 28.08.2024.
//
//

import Foundation
import CoreData


extension TodosItemList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodosItemList> {
        return NSFetchRequest<TodosItemList>(entityName: "TodosItemList")
    }

    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension TodosItemList {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: TodoItem)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: TodoItem)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension TodosItemList : Identifiable {

}
