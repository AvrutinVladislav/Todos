//
//  TodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

final class TodosModuleBuilder {
    static func build() -> TodosViewController {
        let networkService: NetworkService = AppDIContainer.shared.inject()
        let coreDataManager: CoreDataManager = AppDIContainer.shared.inject()
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
