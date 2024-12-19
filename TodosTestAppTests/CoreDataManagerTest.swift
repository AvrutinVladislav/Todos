//
//  CoreDataManagerTest.swift
//  TodosTestAppTests
//
//  Created by Vladislav Avrutin on 18.12.2024.
//

import XCTest
import CoreData
@testable import TodosTestApp

final class CoreDataManagerTest: XCTestCase {
    var coreDataManager: CoreDataManagerImp!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        persistentContainer = NSPersistentContainer(name: "TodosTestApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load persistent store: \(error?.localizedDescription ?? "")")
        }
        coreDataManager = CoreDataManagerImp()
        coreDataManager.persistentContainer = persistentContainer
    }

    override func tearDown() {
        coreDataManager = nil
        persistentContainer = nil
        super.tearDown()
    }

    func testFetchDataSuccess() {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.id = Int64(1)
        todo.isCompleted = false
        todo.todo = "Test todo"
        try? context.save()
        
        let result = coreDataManager.fetchData()
        switch result {
        case .success(let todos):
            XCTAssertEqual(todos.count, 1)
            XCTAssertEqual(todos.first?.todo, "Test todo")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testFetchDataFailure() {
        let result = coreDataManager.fetchData()
        switch result {
        case .success(let todos):
            XCTAssertEqual(todos.count, 0)
        case .failure(let error):
            XCTAssertEqual(error, .fetch)
        }
    }
    
    func testFetchDataForPredicateSuccess() {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.id = Int64(1)
        todo.isCompleted = false
        todo.todo = "Test todo"
        try? context.save()
        
        let result = coreDataManager.fetchData(predicate: NSPredicate(format: "id = %lld", 1))
        switch result {
            case .success(let todo):
                XCTAssertEqual(todo.todo, "Test todo")
                XCTAssertEqual(todo.isCompleted, false)
            case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testAddTodosFromJSONSuccess() {
        let result = coreDataManager.addTodoFromJson(id: Int64(1), text: "Test", isCompleted: false)
        switch result {
        case .success:
            let fetchResult = coreDataManager.fetchData()
            switch fetchResult {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 1)
                XCTAssertEqual(fetchedTodos.first?.todo, "Test")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testUpdateTodo() {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.todo = "Test"
        todo.id = Int64(1)
        todo.isCompleted = false
        try? context.save()
        
        let updateTodo = coreDataManager.updateTodo(text: "Test text is updated", id: 1, isCompeted: false)
        switch updateTodo {
        case .success:
            let result = coreDataManager.fetchData()
            switch result {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 1)
                XCTAssertEqual(fetchedTodos.first?.todo, "Test text is updated")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testDeleteTodo() {
        let context = persistentContainer.viewContext
        let todo = TodoItem(context: context)
        todo.todo = "Test"
        todo.id = Int64(1)
        todo.isCompleted = false
        try? context.save()
        
        let result = coreDataManager.deleteTodo(predicate: NSPredicate(format: "id == %d", 1))
        switch result {
        case .success:
            let fetchedTodos = coreDataManager.fetchData()
            switch fetchedTodos {
            case .success(let fetchedTodos):
                XCTAssertEqual(fetchedTodos.count, 0)
            case .failure:
                XCTFail("Expected success but got failure")
            }
        case .failure:
            XCTFail("Expected success but got failure")
        }        
    }

}
