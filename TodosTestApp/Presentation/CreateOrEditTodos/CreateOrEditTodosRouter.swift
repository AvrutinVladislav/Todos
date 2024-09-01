//
//  CreateOrEditTodosRouter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

protocol CreateOrEditTodosRouterProtocol {
    func popViewController(from view: CreateOrEditTodosViewProtocol)
}

class CreateOrEditTodosRouter: CreateOrEditTodosRouterProtocol {
    weak var viewController: CreateOrEditTodosViewController?
    
    func popViewController(from view: CreateOrEditTodosViewProtocol) {
        guard let viewVC = view as? UIViewController else {
            print("Error for try cast view controller in edit router")
            return
        }
        viewVC.navigationController?.popViewController(animated: true)
    }
}
