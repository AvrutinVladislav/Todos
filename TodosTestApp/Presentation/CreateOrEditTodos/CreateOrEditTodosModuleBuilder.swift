//
//  CreateOrEditTodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

class CreateOrEditTodosModuleBuilder {
    static func build() -> CreateOrEditTodosViewController {
        let coreDataManager = CoreDataManagerImp()
        let interactor = CreateOrEditTodosInteractor(coreDataManager: coreDataManager)
        let router = CreateOrEditTodosRouter()
        let presenter = CreateOrEditTodosPresenter(interactor: interactor, router: router)
        let viewController = CreateOrEditTodosViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
