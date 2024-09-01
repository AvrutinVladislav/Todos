//
//  TodosRouter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

protocol TodosRouterProtocol {
    func pushCreateOrEditViewController(id: Int64?, from view: TodosViewProtocol)
}

final class TodosRouter: TodosRouterProtocol {
    weak var viewController: TodosViewController?
    
    func pushCreateOrEditViewController(id: Int64?, from view: TodosViewProtocol) {
        let state = id == nil ? CreateOrEditTodosState.create : CreateOrEditTodosState.edit
        if let id {
            if let viewVC = view as? UIViewController {
                viewVC.navigationController?
                    .pushViewController(CreateOrEditTodosModuleBuilder.build(id: id,
                                                                             state: state,
                                                                             onFinish: {
                        [weak self] id in
                        guard let self else { return }
                        self.viewController?.presenter?.didAddedTodo(id: id)
                    }),
                                        animated: true)
            }
        } else {
            let idNewTodo = Int64.random(in: 300..<999)
            viewController?.navigationController?
                .pushViewController(CreateOrEditTodosModuleBuilder.build(id: idNewTodo,
                                                                         state: state,
                                                                         onFinish: {
                    [weak self] id in
                    guard let self else { return }
                    self.viewController?.presenter?.didAddedTodo(id: id)
                }),
                                                                     animated: true)
        }
    }
}
