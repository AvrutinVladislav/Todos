//
//  CreateOrEditTodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import Foundation

protocol CreateOrEditTodosInteractorProtocol: AnyObject {
    func saveNewTodoToDB(text: String, state: CreateOrEditTodosState, id: Int64)
    func fetchTodoForEdit(id: Int64)
}

final class CreateOrEditTodosInteractor: CreateOrEditTodosInteractorProtocol {
    weak var presenter: CreateOrEditTodosPresenterProtocol?
    
    private let coreDataManager: CoreDataManager
    
    init( coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveNewTodoToDB(text: String, state: CreateOrEditTodosState, id: Int64) {
        switch state {
        case .create:
            switch coreDataManager.createTodo(text: text, id: id) {
            case .success:
                presenter?.onFineshed(id: id)
            case .failure(let error):
                print(error.errorDescription)
            }
        case .edit:
            switch coreDataManager.updateTodo(text: text, id: id, isCompeted: false) {
            case .success:
                presenter?.onFineshed(id: id)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func fetchTodoForEdit(id: Int64) {
        switch coreDataManager.fetchData(predicate: NSPredicate(format: "id = %lld", id)) {
        case .success(let todo):
            presenter?.editTodo(text: todo.todo ?? "")
        case .failure(let error):
            print(error.errorDescription)
        }
    }
    
}
