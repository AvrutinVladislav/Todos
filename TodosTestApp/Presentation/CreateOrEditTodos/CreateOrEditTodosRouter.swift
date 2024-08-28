//
//  CreateOrEditTodosRouter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

protocol CreateOrEditTodosRouterProtocol {
    func popViewController()
}

class CreateOrEditTodosRouter: CreateOrEditTodosRouterProtocol {
    weak var viewController: CreateOrEditTodosViewController?
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
