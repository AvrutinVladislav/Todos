//
//  TodosPresenter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosPresenterProtocol: AnyObject {
    func viewDidLoad()
    func todosDataDidLoad(todos: TodosSectionsModel)
    func completeButtonDidTap(todo: inout Todo)
}

class TodosPresenter {
    weak var view: TodosViewProtocol?
    var router: TodosRouterProtocol
    var interactor: TodosInteractorProtocol

    init(interactor: TodosInteractorProtocol, router: TodosRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TodosPresenter: TodosPresenterProtocol {
    func viewDidLoad() {
        interactor.loadData()
    }
    
    func todosDataDidLoad(todos: TodosSectionsModel) {
        view?.prepareDataForCells(todos: todos)
    }
    
    func completeButtonDidTap(todo: inout Todo) {
        todo.isCompleted.toggle()
    }
}
