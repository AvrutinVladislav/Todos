//
//  TodosRouter.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

protocol TodosRouterProtocol {
    func pushCreateOrEditViewController(id: Int64)
}

class TodosRouter: TodosRouterProtocol {
    weak var viewController: TodosViewController?
    
    func pushCreateOrEditViewController(id: Int64) {
        let vc = CreateOrEditTodosViewController()
        vc.onFinish = { [weak self] id in
//            viewController?.presenter.
        }
        viewController?.navigationController?.pushViewController(CreateOrEditTodosViewController(), animated: true)
    }
}
