//
//  TodosModuleBuilder.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

class TodosModuleBuilder {
    static func build() -> TodosViewController {
        let interactor = TodosInteractor()
        let router = TodosRouter()
        let presenter = TodosPresenter(interactor: interactor, router: router)
        let storyboard = UIStoryboard(name: "Todos", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Todos") as! TodosViewController
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
