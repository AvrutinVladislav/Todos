//
//  CreateOrEditTodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosPresenterProtocol: AnyObject {
    func viewDidLoad(todoId: Int64?, state: CreateOrEditTodosState)
    func backButtonDidTap()
    func saveButtonDidTap(text: String)
    func onFineshed(id: Int64)
    func editTodo(text: String)
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

    init(interactor: CreateOrEditTodosInteractorProtocol, router: CreateOrEditTodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CreateOrEditTodosPresenter: CreateOrEditTodosPresenterProtocol {
    func viewDidLoad(todoId: Int64?, state: CreateOrEditTodosState) {
        self.todoId = todoId
        if state == .edit,
           let todoId {
            interactor.fetchTodoForEdit(id: todoId)
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
    
    func editTodo(text: String) {
        view?.prepareTodoTextForEdit(text: text)
    }
    
}
