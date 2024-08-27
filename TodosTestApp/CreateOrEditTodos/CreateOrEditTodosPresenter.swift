//
//  CreateOrEditTodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosPresenterProtocol: AnyObject {
}

class CreateOrEditTodosPresenter {
    weak var view: CreateOrEditTodosViewProtocol?
    var router: CreateOrEditTodosRouterProtocol
    var interactor: CreateOrEditTodosInteractorProtocol

    init(interactor: CreateOrEditTodosInteractorProtocol, router: CreateOrEditTodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension CreateOrEditTodosPresenter: CreateOrEditTodosPresenterProtocol {
}
