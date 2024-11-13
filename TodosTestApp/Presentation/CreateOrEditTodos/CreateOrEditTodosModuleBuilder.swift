//
//  CreateOrEditTodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

final class CreateOrEditTodosModuleBuilder {
    static func build(id: Int64, state: CreateOrEditTodosState, onFinish: @escaping (Int64) -> Void) -> CreateOrEditTodosViewController {
        let coreDataManager: CoreDataManager = AppDIContainer.shared.inject()
        let interactor = CreateOrEditTodosInteractor(coreDataManager: coreDataManager)
        let router = CreateOrEditTodosRouter()
        let presenter = CreateOrEditTodosPresenter(interactor: interactor, router: router)
        let viewController = CreateOrEditTodosViewController()
        presenter.view  = viewController
        presenter.state = state
        viewController.presenter = presenter
        viewController.state = state
        viewController.todoId = id
        viewController.onFinish = onFinish
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
