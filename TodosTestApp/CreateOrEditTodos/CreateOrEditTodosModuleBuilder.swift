//
//  CreateOrEditTodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

class CreateOrEditTodosModuleBuilder {
    static func build() -> CreateOrEditTodosViewController {
        let interactor = CreateOrEditTodosInteractor()
        let router = CreateOrEditTodosRouter()
        let presenter = CreateOrEditTodosPresenter(interactor: interactor, router: router)
        let storyboard = UIStoryboard(name: "CreateOrEditTodos", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateOrEditTodos") as! CreateOrEditTodosViewController
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}