//
//  CreateOrEditTodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

protocol CreateOrEditTodosViewProtocol: AnyObject {
}

class CreateOrEditTodosViewController: UIViewController {
    // MARK: - Public
    var presenter: CreateOrEditTodosPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension CreateOrEditTodosViewController {
    func initialize() {
    }
}

// MARK: - CreateOrEditTodosViewProtocol
extension CreateOrEditTodosViewController: CreateOrEditTodosViewProtocol {
}
