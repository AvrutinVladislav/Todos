//
//  TodosRouter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosRouterProtocol {
    func pushCreateOrEditViewController(id: Int64?)
}

class TodosRouter: TodosRouterProtocol {
    weak var viewController: TodosViewController?
    
    func pushCreateOrEditViewController(id: Int64?) {
        let state = id == nil ? CreateOrEditTodosState.create : CreateOrEditTodosState.edit
        if let id {
            viewController?.navigationController?
                .pushViewController(CreateOrEditTodosModuleBuilder.build(id: id,
                                                                         state: state,
                                                                         onFinish: {
                    [weak self] id in
                    guard let self else { return }
                    self.viewController?.presenter?.didAddedTodo(id: id)
                }),
                                                                     animated: true)
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
