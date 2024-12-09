//
//  CreateOrEditTodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import Foundation

protocol CreateOrEditTodosPresenterProtocol: AnyObject {
    func viewDidLoad(todoId: Int64?, title: String?, state: CreateOrEditTodosState)
    func backButtonDidTap()
    func saveButtonDidTap(text: String)
    func onFineshed(id: Int64)
    func editTodo(model: TodoCellData)
}

enum CreateOrEditTodosState {
    case create
    case edit
}

final class CreateOrEditTodosPresenter {
    weak var view: CreateOrEditTodosViewProtocol?
    var router: CreateOrEditTodosRouterProtocol
    var interactor: CreateOrEditTodosInteractorProtocol
    var state = CreateOrEditTodosState.create
    var todoId: Int64?
    var title: String?

    init(interactor: CreateOrEditTodosInteractorProtocol, router: CreateOrEditTodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CreateOrEditTodosPresenter: CreateOrEditTodosPresenterProtocol {
    func viewDidLoad(todoId: Int64?, title: String?, state: CreateOrEditTodosState) {
        self.todoId = todoId
        if state == .edit,
           let todoId, let title {
            interactor.fetchTodoForEdit(id: todoId, title: title)
        } else {
            editTodo(model: TodoCellData(item: Todo(todoId: Int.random(in: 300..<999),
                                                    userId: 14,
                                                    isCompleted: false,
                                                    todo: "Введите описание"),
                                         title: "",
                                         date: Date()))
        }
    }
    
    func backButtonDidTap() {
        if let view {
            router.popViewController(from: view)
        }
    }
    
    func saveButtonDidTap(text: String) {
        if let todoId {
            interactor.saveNewTodoToDB(text: text, state: state, id: todoId)
        }
    }
    
    func onFineshed(id: Int64) {
        view?.onFinished(id: id)
        if let view {
            router.popViewController(from: view)
        }
    }
    
    func editTodo(model: TodoCellData) {
        view?.prepareTodoTextForEdit(model: model)
    }
    
}
