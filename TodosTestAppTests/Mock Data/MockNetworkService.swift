//
//  MockNetworkService.swift
//  TodosTestAppTests
//
//  Created by Vladislav Avrutin on 18.12.2024.
//

import XCTest
@testable import TodosTestApp

class MockNetworkService: NetworkService {
    var request: Result<TodosSectionsModel, NetworkError>?
    
    func getData(completion: @escaping (Result<TodosSectionsModel, NetworkError>) -> Void) {
        guard let request else {
            XCTFail("Result is not set")
            return
        }
        completion(request)
    }
}
