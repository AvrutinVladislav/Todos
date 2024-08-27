//
//  TodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

protocol TodosViewProtocol: AnyObject {
    func prepareDataForCells(todos: TodosSectionsModel)
}

class TodosViewController: UIViewController {
    // MARK: - Public
    var presenter: TodosPresenterProtocol?
    
    // MARK: - Private properties
    private let addTodoButton = UIButton()
    private let todoTableView = UITableView()
    
    private var todosLoadList: [Todo] = []

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private functions
private extension TodosViewController {
    func setupUI() {
        todoTableView.translatesAutoresizingMaskIntoConstraints = false
        todoTableView.register(TodosTableViewCell.self, forCellReuseIdentifier: TodosTableViewCell.identifier)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonDidTap), for: .touchUpInside)
        addTodoButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTodoButton.contentVerticalAlignment = .fill
        addTodoButton.contentHorizontalAlignment = .fill
        addTodoButton.frame = .init(x: 0, y: 0, width: 35, height: 35)
        addTodoButton.tintColor = .white
        addTodoButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addTodoButton)
        view.addSubview(todoTableView)
        
        addTodoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 10, left: 0, bottom: 0, right: -10))
        
        todoTableView.anchor(top: addTodoButton.bottomAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
    }
    
    @objc func addTodoButtonDidTap() {
        
    }
}

//MARK: - TableViewDelegate & TableViewDataSource
extension TodosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosLoadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodosTableViewCell.identifier, for: indexPath) as? TodosTableViewCell else { return UITableViewCell() }
        cell.configureCell(model: todosLoadList[indexPath.row])
        return cell
    }
    
}

// MARK: - TodosViewProtocol
extension TodosViewController: TodosViewProtocol {
    func prepareDataForCells(todos: TodosSectionsModel) {
        todosLoadList = todos.todos
        DispatchQueue.main.async { [weak self] in 
            self?.todoTableView.reloadData()
        }
    }
    
}
