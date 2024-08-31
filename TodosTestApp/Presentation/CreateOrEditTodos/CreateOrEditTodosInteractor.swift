//
//  CreateOrEditTodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosInteractorProtocol: AnyObject {
    func saveNewTodoToDB(text: String, state: CreateOrEditTodosState)
    func fetchTodoForEdit(id: Int64)
}

class CreateOrEditTodosInteractor: CreateOrEditTodosInteractorProtocol {
    weak var presenter: CreateOrEditTodosPresenterProtocol?
    
    private let coreDataManager: CoreDataManager
    
    init( coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveNewTodoToDB(text: String, state: CreateOrEditTodosState) {
        let id = Int64.random(in: 300..<999)
        switch state {
        case .create:
            switch coreDataManager.createTodo(text: text, id: id) {
            case .success(let result):
                presenter?.callBackId(id: id)
            case .failure(let error):
                print("Error for create todo")
            }
        case .edit:
            break
        }
    }
    func fetchTodoForEdit(id: Int64) {
        
    }

}
