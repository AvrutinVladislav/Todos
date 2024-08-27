//
//  NetworkService.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 27.08.2024.
//

import Foundation

enum NetworkError: Error {
    case responceError(Error)
    case invalidateURL
    case decodeError
    case invalidateData
    
    var errorDescription: String {
        switch self {
        case .invalidateURL:
            return "Invalidate URL"
        case .decodeError:
            return "Error to decode data"
        case .invalidateData:
            return "invalidate data"
        case .responceError:
            return ""
        }
    }
}

protocol NetworkService {
    func getData(completion: @escaping(Result<TodosSectionsModel, NetworkError>) -> Void)
}

final class NetworkServiceImp: NetworkService {
    
    private let mokJsonUrl = "https://dummyjson.com/todos"

    func getData(completion: @escaping(Result<TodosSectionsModel, NetworkError>) -> Void) {
        guard let url = URL(string: mokJsonUrl) else {
            completion(.failure(.invalidateURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.responceError(error)))
            }
            if data == nil {
                completion(.failure(.invalidateData))
            }
            guard let data, let todos = try? JSONDecoder().decode(TodosSectionsModel.self, from: data)
            else {
                completion(.failure(.decodeError))
                return
            }
            completion(.success(todos))
        }
        task.resume()
    }
  
}
