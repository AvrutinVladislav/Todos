//
//  CreateOrEditTodosInteractor.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosInteractorProtocol: AnyObject {
}

class CreateOrEditTodosInteractor: CreateOrEditTodosInteractorProtocol {
    weak var presenter: CreateOrEditTodosPresenterProtocol?
}
