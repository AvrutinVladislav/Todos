//
//  AppDIContainer.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 11.11.2024.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class AppDIContainer {
    static let shared = AppDIContainer()
    let container = Container()
    private init() {
        registerDependencies()
    }
    func inject<T>() -> T {
        if let service = container.resolve(T.self) {
            return service
        } else {
            fatalError("Dependency \(T.self) not injected")
        }
    }
    private func registerDependencies() {
        container.autoregister(NetworkService.self, initializer: NetworkServiceImp.init)
        container.autoregister(CoreDataManager.self, initializer: CoreDataManagerImp.init)
        
    }
}
