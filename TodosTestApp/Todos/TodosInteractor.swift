//
//  TodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosInteractorProtocol: AnyObject {
}

class TodosInteractor: TodosInteractorProtocol {
    weak var presenter: TodosPresenterProtocol?
}
