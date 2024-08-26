//
//  TodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

protocol TodosViewProtocol: AnyObject {
}

class TodosViewController: UIViewController {
    // MARK: - Public
    var presenter: TodosPresenterProtocol?
    var testcells = [
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12"),
        TodosModel(todoId: "12", userId: "12")
    ]
    
    // MARK: - Private properties
    private let addTodoButton = UIButton()
    private let todoTableView = UITableView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private functions
private extension TodosViewController {
    func setupUI() {
        todoTableView.register(TodosTableViewCell.self, forCellReuseIdentifier: TodosTableViewCell.identifier)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
//        view.addSubview(addTodoButton)
        view.addSubview(todoTableView)
        
        todoTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}

//MARK: - TableViewDelegate & TableViewDataSource
extension TodosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testcells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodosTableViewCell.identifier, for: indexPath) as? TodosTableViewCell else { return UITableViewCell() }
        cell.configureCell(model: testcells[indexPath.row])
        return cell
    }
    
}

// MARK: - TodosViewProtocol
extension TodosViewController: TodosViewProtocol {
}
