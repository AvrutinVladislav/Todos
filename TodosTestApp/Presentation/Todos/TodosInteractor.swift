//
//  TodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
    func prepareData()
    func fetchDataFromDB() -> [TodoCellData]
    func fetchDataFromDBById(id: Int64)
    func updateCoreData(todo: TodoCellData)
}

final class TodosInteractor {
    
    weak var presenter: TodosPresenterProtocol?
    
    private let networkService: NetworkService
    private let coreDataManager: CoreDataManager
    
    init(networkService: NetworkService, coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
}

extension TodosInteractor {
    func checkChanges(todos: TodosSectionsModel) {
        switch self.coreDataManager.fetchData() {
        case .success(let fetchResult):
            let data = fetchResult.map { item in
                Todo(todoId: Int(item.id),
                     userId: Int(item.userId),
                     isCompleted: item.isCompleted,
                     todo: item.todo ?? "")
            }
            todos.todos.forEach { todo in
                if data.contains(where: {$0.todoId == todo.todoId
                    && $0.isCompleted == todo.isCompleted
                    && $0.todo == todo.todo}) {
                    self.updateCoreData(todo: TodoCellData(todo: todo, date: Date()))
                } else {
                    self.cdAddDataFromFson(todo: todo)
                }
            }
        case .failure(_):
            print("Error fetch data when check changes core data with json")
        }
    }
    
}

extension TodosInteractor: TodosInteractorProtocol {
    func prepareData() {
        networkService.getData { [weak self] todos in
            switch todos {
            case .success(let todos):
                guard let self else { return }
                checkChanges(todos: todos)
                switch coreDataManager.fetchData() {
                case .success(let result):
                    let data = result.map {item in
                        TodoCellData(todo: Todo(todoId: Int(item.id),
                                                userId: Int(item.userId),
                                                isCompleted: item.isCompleted,
                                                todo: item.todo ?? ""),
                                     date: Date())
                    }
                    presenter?.todosDataDidLoad(todos: data)
                case .failure(_):
                    print("Error fetch data when load from json")
                }
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    func fetchDataFromDB() -> [TodoCellData] {
        switch coreDataManager.fetchData() {
        case .success(let todos):
            let todosList = todos.map { item -> TodoCellData in
                return TodoCellData(todo: Todo(todoId: Int(item.id),
                                               userId: Int(item.userId),
                                               isCompleted: item.isCompleted,
                                               todo: item.todo ?? ""),
                                    date: Date()
                                   )
            }
            return todosList
        case .failure(_):
            print("Error to fetch data from Core Data")
            return []
        }        
    }
    
    func cdAddDataFromFson(todo: Todo) {
        switch self.coreDataManager.addTodoFromJson(id: Int64(todo.todoId),
                                                    text: todo.todo,
                                                    isCompleted: todo.isCompleted) {
        case .success():
            break
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchDataFromDBById(id: Int64) {
       
    }
    
    func updateCoreData(todo: TodoCellData) {
        switch coreDataManager.updateTodo(todo: todo) {
        case .success(_):
            break
        case .failure(_):
            print("Error to update Core Data")
        }
    }
    
}
