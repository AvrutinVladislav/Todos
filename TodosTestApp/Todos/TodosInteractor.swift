//
//  TodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosInteractorProtocol: AnyObject {
    func loadData()
}

final class TodosInteractor {
    
    weak var presenter: TodosPresenterProtocol?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension TodosInteractor: TodosInteractorProtocol {
    func loadData() {
        networkService.getData { [weak self] todos in
            switch todos {
            case .success(let todos):
                self?.presenter?.todosDataDidLoad(todos: todos)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
}
