//
//  TodoItem+CoreDataProperties.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 28.08.2024.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var complited: Bool
    @NSManaged public var todo: String?
    @NSManaged public var todosList: TodosItemList?

}

extension TodoItem : Identifiable {

}
