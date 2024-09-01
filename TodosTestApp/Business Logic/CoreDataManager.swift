//
//  CoreDataManager.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 28.08.2024.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func fetchData() -> Result<[TodoItem], CoreDataError>
    func fetchData(predicate: NSPredicate) -> Result<TodoItem, CoreDataError>
    func addTodoFromJson(id: Int64, text: String, isCompleted: Bool) -> Result<Void, CoreDataError>
    func updateTodo(text: String, id: Int64, isCompeted: Bool) -> Result<Void, CoreDataError>
    func deleteTodo(predicate: NSPredicate) -> Result<Void, CoreDataError>
    func createTodo(text: String, id: Int64) -> Result<TodoItem, CoreDataError>
}

public final class CoreDataManagerImp: CoreDataManager {

    init(){}
    
    func fetchData() -> Result<[TodoItem], CoreDataError> {
        let context = persistentContainer.viewContext
        
        do {
            let item = try context.fetch(TodoItem.fetchRequest())
            return .success(item)
        } catch {
            return .failure(.fetch)
        }
    }
    
    func fetchData(predicate: NSPredicate) -> Result<TodoItem, CoreDataError> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            var note = TodoItem()
            if let item = try context.fetch(fetchRequest).first {
                note = item }
            return .success(note)
        } catch {
            return .failure(.fetchById)
        }
    }
    
    func addTodoFromJson(id: Int64, text: String, isCompleted: Bool) -> Result<Void, CoreDataError> {
        let context = persistentContainer.viewContext
        let newTodo = TodoItem(context: context)
        newTodo.id = id
        newTodo.isCompleted = isCompleted
        newTodo.todo = text
        saveContext()
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(.fillFromJson)
        }
    }
    
    func updateTodo(text: String, id: Int64, isCompeted: Bool) -> Result<Void, CoreDataError> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %lld", id)
        saveContext()
        do {
            if let result = try context.fetch(fetchRequest).first {
                result.todo = text
                result.isCompleted = isCompeted
                result.date = Date()
                try context.save()
            }
            saveContext()
            return .success(())
        } catch {
            return .failure(.update)
        }
    }
    
    func deleteTodo(predicate: NSPredicate) -> Result<Void, CoreDataError> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
                saveContext()
            }
        } catch {
            return .failure(.delete)
        }
        saveContext()
        return .success(())
    }

    func createTodo(text: String, id: Int64) -> Result<TodoItem, CoreDataError>  {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.todo = text
        todo.id = id
        saveContext()
        do {
            try context.save()
            return .success(todo)
        } catch {
            return .failure(.create)
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TodosTestApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

enum CoreDataError: Error {
    case fetch
    case fetchById
    case fillFromJson
    case update
    case create
    case delete
    
    var errorDescription: String {
        switch self {
        case .fetch:
            return "Error fetch data from DB"
        case .fetchById:
            return "Error fetch data from DB by id"
        case .update:
            return "Error to update DB"
        case .create:
            return "Error save bew todo in DB"
        case .delete:
            return "Error delete todo from DB"
        case .fillFromJson:
            return "Error fetch data when load from json"
        }
    }
}
