//
//  TodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosInteractorProtocol: AnyObject {
    func loadData()
    func cdFetchData()
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
    
    func cdFetchData() {
        switch coreDataManager.fetchData() {
        case .success(let todos):
            print(todos)
        case .failure(_):
            print("Error to fetch data from Core Data")
        }
    }
    
}
