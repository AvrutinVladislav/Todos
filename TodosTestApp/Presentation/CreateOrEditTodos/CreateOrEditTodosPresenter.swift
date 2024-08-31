//
//  CreateOrEditTodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosPresenterProtocol: AnyObject {
    func backButtonDidTap()
    func saveButtonDidTap(text: String)
    func callBackId(id: Int64)
}

enum CreateOrEditTodosState {
    case create
    case edit
}

class CreateOrEditTodosPresenter {
    weak var view: CreateOrEditTodosViewProtocol?
    var router: CreateOrEditTodosRouterProtocol
    var interactor: CreateOrEditTodosInteractorProtocol
    var state = CreateOrEditTodosState.create

    init(interactor: CreateOrEditTodosInteractorProtocol, router: CreateOrEditTodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CreateOrEditTodosPresenter: CreateOrEditTodosPresenterProtocol {
    func backButtonDidTap() {
        router.popViewController()
    }
    
    func saveButtonDidTap(text: String) {
        switch state {
        case .create:
            interactor.saveNewTodoToDB(text: text, state: state)
        case .edit:
            break
        }
    }
    
    func callBackId(id: Int64) {
        view?.onFinished()
    }
    
}
