//
//  CoreDataManager.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 28.08.2024.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func fetchData() -> Result<[TodoItem], Error>
    func fetchData(predicate: NSPredicate) -> Result<TodoItem, Error>
    func addTodoFromJson(id: Int64, text: String, isCompleted: Bool) -> Result<Void, Error>
    func updateTodo(todo: TodoCellData) -> Result<Void, Error>
    func deleteTodo(predicate: NSPredicate) -> Result<Void, Error>
    func createTodo(text: String, id: Int64) -> Result<TodoItem, Error>
}

public final class CoreDataManagerImp: CoreDataManager {

    init(){}
    
    func fetchData() -> Result<[TodoItem], Error> {
        let context = persistentContainer.viewContext
        
        do {
            let item = try context.fetch(TodoItem.fetchRequest())
            return .success(item)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchData(predicate: NSPredicate) -> Result<TodoItem, Error> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            var note = TodoItem()
            if let item = try context.fetch(fetchRequest).first {
                note = item }
            return .success(note)
        } catch {
            return .failure(error)
        }
    }
    
    func addTodoFromJson(id: Int64, text: String, isCompleted: Bool) -> Result<Void, Error> {
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
            return .failure(error)
        }
    }
    
    func updateTodo(todo: TodoCellData) -> Result<Void, Error> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %lld", todo.todo.todoId)
        saveContext()
        do {
            if let result = try context.fetch(fetchRequest).first {
                result.todo = todo.todo.todo
                result.isCompleted = todo.todo.isCompleted
                result.date = todo.date
                try context.save()
            }
            saveContext()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteTodo(predicate: NSPredicate) -> Result<Void, Error> {
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
            return .failure(error)
        }
        saveContext()
        return .success(())
    }

    func createTodo(text: String, id: Int64) -> Result<TodoItem, Error>  {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.todo = text
        todo.id = id
        saveContext()
        do {
            try context.save()
            return .success(todo)
        } catch {
            return .failure(error)
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
