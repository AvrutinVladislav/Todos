//
//  TodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

class TodosModuleBuilder {
    static func build() -> TodosViewController {
        let networkService = NetworkServiceImp()
        let coreDataManager = CoreDataManagerImp()
        let interactor = TodosInteractor(networkService: networkService, coreDataManager: coreDataManager)
        let router = TodosRouter()
        let presenter = TodosPresenter(interactor: interactor, router: router)
        let viewController = TodosViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
