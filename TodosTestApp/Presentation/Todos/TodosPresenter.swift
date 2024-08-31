//
//  TodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import Foundation

protocol TodosPresenterProtocol: AnyObject {
    func viewDidLoad()
    func todosDataDidLoad(todos: [TodoCellData])
    func completeButtonDidTap(todo: inout TodoCellData)
    func pushCreateOrEditVC(id: Int64)
    func didAddedTodo(id: Int64)
    func buildCell(id: Int64, userId: Int64, isCompleted: Bool, todo: String, date: Date) -> TodoCellData
    func checkChanges()
}

class TodosPresenter {
    weak var view: TodosViewProtocol?
    var router: TodosRouterProtocol
    var interactor: TodosInteractorProtocol
    var todos: [TodoCellData] = []

    init(interactor: TodosInteractorProtocol, router: TodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TodosPresenter: TodosPresenterProtocol {
    func viewDidLoad() {
        interactor.prepareData()
    }
    
    func todosDataDidLoad(todos: [TodoCellData]) {
        self.todos = todos
        view?.prepareDataForCells(todos: todos)
    }
    
    func completeButtonDidTap(todo: inout TodoCellData) {
        todo.todo.isCompleted.toggle()
        interactor.updateCoreData(todo: todo)
        todos.forEach { item in
            if item.todo.todoId == todo.todo.todoId &&
                item.todo.isCompleted != todo.todo.isCompleted {
                if let index = self.todos.firstIndex(where: {$0.todo.todoId == todo.todo.todoId}) {
                    todos.remove(at: index)
                    todos.insert(todo, at: index)
                }
            }
        }
        view?.prepareDataForCells(todos: todos)
    }
    
    func pushCreateOrEditVC(id: Int64) {
        
    }
    
    func didAddedTodo(id: Int64) {
        interactor.fetchDataFromDB()
    }
    
    func buildCell(id: Int64, userId: Int64, isCompleted: Bool, todo: String, date: Date) -> TodoCellData {
        return TodoCellData(todo: Todo(todoId: Int(id),
                                       userId: Int(userId),
                                       isCompleted: isCompleted,
                                       todo: todo),
                            date: date)
    }
    
    func checkChanges() {
        
    }
    
}
