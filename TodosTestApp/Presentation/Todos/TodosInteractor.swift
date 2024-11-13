//
//  TodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import Foundation
import RxSwift
import RxCocoa

protocol TodosInteractorProtocol: AnyObject {
    func prepareData()
    func prepareRxData()
    func fetchDataFromDB() -> [TodoCellData]
    func updateEditTodo(id: Int64, todosList: inout [TodoCellData])
    func updateCoreData(todo: TodoCellData)
    func deleteTodo(todo: TodoCellData)
}

final class TodosInteractor {
    
    weak var presenter: TodosPresenterProtocol?
    let firstLaunchComplited = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
    private let networkService: NetworkService
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkService,
         coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
}

extension TodosInteractor {
    func addedRxTodosToCoreData(todos: Observable<TodosSectionsModel>) {
        todos.subscribe {[weak self] todos in
            guard let self else { return }
            switch self.coreDataManager.fetchData() {
                case .success(let fetchResult):
                let data = fetchResult.map { item in
                    Todo(todoId: Int(item.id),
                         userId: Int(item.userId),
                         isCompleted: item.isCompleted,
                         todo: item.todo ?? "")
                }
                guard !firstLaunchComplited else { return }
                todos.todos.forEach { todo in
                    if data.contains(where: {$0.todoId == todo.todoId
                        && $0.isCompleted == todo.isCompleted
                        && $0.todo == todo.todo})
                    {
                        self.updateCoreData(todo: TodoCellData(item: todo, date: Date()))
                    } else {
                        self.fillCoreDataFromFson(todo: todo)
                    }
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func addedTodosToDB(todos: TodosSectionsModel) {
        switch self.coreDataManager.fetchData() {
        case .success(let fetchResult):
            let data = fetchResult.map { item in
                Todo(todoId: Int(item.id),
                     userId: Int(item.userId),
                     isCompleted: item.isCompleted,
                     todo: item.todo ?? "")
            }
            guard !firstLaunchComplited else { return }
            todos.todos.forEach { todo in
                if data.contains(where: {$0.todoId == todo.todoId
                    && $0.isCompleted == todo.isCompleted
                    && $0.todo == todo.todo}) {
                    self.updateCoreData(todo: TodoCellData(item: todo, date: Date()))
                } else {
                    self.fillCoreDataFromFson(todo: todo)
                }
            }
        case .failure(let error):
            print(error.errorDescription)
        }
    }
    
}

extension TodosInteractor: TodosInteractorProtocol {
    func prepareRxData() {
        if !firstLaunchComplited {
            let todos = networkService.getDataRx()
            addedRxTodosToCoreData(todos: todos)
            switch coreDataManager.fetchData() {
            case .success(let result):
                let data = result.map {item in
                    TodoCellData(item: Todo(todoId: Int(item.id),
                                            userId: Int(item.userId),
                                            isCompleted: item.isCompleted,
                                            todo: item.todo ?? ""),
                                 date: Date())
                }
                presenter?.todosDataDidLoad(todos: data)
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.synchronize()
            case .failure(let error):
                print(error.errorDescription)
            }
        } else {
            switch coreDataManager.fetchData() {
            case .success(let result):
                let data = result.map {item in
                    TodoCellData(item: Todo(todoId: Int(item.id),
                                            userId: Int(item.userId),
                                            isCompleted: item.isCompleted,
                                            todo: item.todo ?? ""),
                                 date: Date())
                }
                presenter?.todosDataDidLoad(todos: data)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func prepareData() {
        if !firstLaunchComplited {
            networkService.getData { [weak self] todos in
                switch todos {
                case .success(let todos):
                    guard let self else { return }
                    addedTodosToDB(todos: todos)
                    switch coreDataManager.fetchData() {
                    case .success(let result):
                        let data = result.map {item in
                            TodoCellData(item: Todo(todoId: Int(item.id),
                                                    userId: Int(item.userId),
                                                    isCompleted: item.isCompleted,
                                                    todo: item.todo ?? ""),
                                         date: Date())
                        }
                        presenter?.todosDataDidLoad(todos: data)
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                        UserDefaults.standard.synchronize()
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                case .failure(let failure):
                    print(failure.errorDescription)
                }
            }
        } else {
            switch coreDataManager.fetchData() {
            case .success(let result):
                let data = result.map {item in
                    TodoCellData(item: Todo(todoId: Int(item.id),
                                            userId: Int(item.userId),
                                            isCompleted: item.isCompleted,
                                            todo: item.todo ?? ""),
                                 date: Date())
                }
                presenter?.todosDataDidLoad(todos: data)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func fetchDataFromDB() -> [TodoCellData] {
        switch coreDataManager.fetchData() {
        case .success(let todos):
            let todosList = todos.map { item -> TodoCellData in
                return TodoCellData(item: Todo(todoId: Int(item.id),
                                               userId: Int(item.userId),
                                               isCompleted: item.isCompleted,
                                               todo: item.todo ?? ""),
                                    date: Date()
                                   )
            }
            return todosList
        case .failure(let error):
            print(error.errorDescription)
            return []
        }        
    }
    
    func fillCoreDataFromFson(todo: Todo) {
        switch self.coreDataManager.addTodoFromJson(id: Int64(todo.todoId),
                                                    text: todo.todo,
                                                    isCompleted: todo.isCompleted) {
        case .success():
            break
        case .failure(let error):
            print(error.errorDescription)
        }
    }
    
    func updateEditTodo(id: Int64, todosList: inout [TodoCellData]) {
        switch coreDataManager.fetchData(predicate: NSPredicate(format: "id = %lld", id)) {
        case .success(let item):
            let cell = TodoCellData(item: Todo(todoId: Int(item.id),
                                               userId: Int(item.userId),
                                               isCompleted: item.isCompleted,
                                               todo: item.todo ?? ""),
                                    date: Date())
            if let index = todosList.firstIndex(where: { $0.item.todoId == cell.item.todoId}) {
                todosList.remove(at: index)
                todosList.insert(cell, at: 0)
            } else {
                todosList.insert(cell, at: 0)
            }
        case .failure(let error):
            print(error.errorDescription)
        }
    }
    
    func updateCoreData(todo: TodoCellData) {
        switch coreDataManager.updateTodo(text: todo.item.todo, id: Int64(todo.item.todoId), isCompeted: todo.item.isCompleted) {
        case .success(_):
            break
        case .failure(let error):
            print(error.errorDescription)
        }
    }
    
    func deleteTodo(todo: TodoCellData) {
        switch coreDataManager.deleteTodo(predicate: NSPredicate(format: "id = %lld", todo.item.todoId)) {
        case .success():
            break
        case .failure(let error):
            print(error.errorDescription)
        }
    }
}
