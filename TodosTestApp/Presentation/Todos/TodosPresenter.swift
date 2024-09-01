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
    func pushCreateOrEditVC(id: Int64?)
    func didAddedTodo(id: Int64)
    func deleteTodo(todo: TodoCellData)
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
        todo.item.isCompleted.toggle()
        interactor.updateCoreData(todo: todo)
        todos.forEach { item in
            if item.item.todoId == todo.item.todoId &&
                item.item.isCompleted != todo.item.isCompleted {
                if let index = self.todos.firstIndex(where: {$0.item.todoId == todo.item.todoId}) {
                    todos.remove(at: index)
                    todos.insert(todo, at: index)
                }
            }
        }
        view?.prepareDataForCells(todos: todos)
    }
    
    func pushCreateOrEditVC(id: Int64?) {
        router.pushCreateOrEditViewController(id: id)
    }
    
    func didAddedTodo(id: Int64) {
        interactor.updateEditTodo(id: id, todosList: &todos)
        view?.prepareDataForCells(todos: todos)
    }
    
    func deleteTodo(todo: TodoCellData) {
        interactor.deleteTodo(todo: todo)
        if let index = todos.firstIndex(where: {$0.item.todoId == todo.item.todoId}) {
            todos.remove(at: index)
        }
        view?.prepareDataForCells(todos: todos)
    }
    
}
