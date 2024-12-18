//
//  NetworkServiceTest.swift
//  TodosTestAppTests
//
//  Created by Vladislav Avrutin on 18.12.2024.
//

import XCTest
@testable import TodosTestApp

final class NetworkServiceTest: XCTestCase {
    
    var networkService: MockNetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = MockNetworkService()
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        try super.tearDownWithError()
    }
    
    func testGetData_Success() {
        let expectedModel = TodosSectionsModel(todos: [], total: 100, skip: 0, limit: 50)
        networkService.request = .success(expectedModel)
        
        let expectation = self.expectation(description: "Complition should be called")
        networkService.getData { result in
            switch result {
            case .success(let model):
                XCTAssertFalse((model.todos.count != 0), "\(expectedModel.todos.count)")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testGetData_Failure_InvalidURL() {
        networkService.request = .failure(.invalidateURL)
        let expectation = self.expectation(description: "Complition should be called")
        networkService.getData { request in
            switch request {
                case .success:
                XCTFail("Expected failure, but got success")
                case .failure(let error):
                XCTAssertEqual(error, .invalidateURL)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testGetData_DecodeError() {
        networkService.request = .failure(.decodeError)
        let expectation = self.expectation(description: "Complition should be called")
        networkService.getData { request in
            switch request {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .decodeError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
}
