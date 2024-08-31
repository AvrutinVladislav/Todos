//
//  TodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 26.08.2024
//

import UIKit

protocol TodosViewProtocol: AnyObject {
    func prepareDataForCells(todos: [TodoCellData])
    func reloadTableView()
}

class TodosViewController: UIViewController {
    // MARK: - Public
    var presenter: TodosPresenterProtocol?
    
    // MARK: - Private properties
    private let addTodoButton = UIButton()
    private let todoTableView = UITableView()
    
    private var todosLoadList: [TodoCellData] = []

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
        todoTableView.register(TodosTableViewCell.self, forCellReuseIdentifier: TodosTableViewCell.identifier)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.separatorStyle = .none
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonDidTap), for: .touchUpInside)
        addTodoButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTodoButton.contentVerticalAlignment = .fill
        addTodoButton.contentHorizontalAlignment = .fill
        addTodoButton.frame = .init(x: 0, y: 0, width: 35, height: 35)
        addTodoButton.tintColor = .white
        
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
        navigationController?.pushViewController(CreateOrEditTodosModuleBuilder.build(), animated: true)
    }
    
}

//MARK: - TableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosLoadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodosTableViewCell.identifier, for: indexPath) as? TodosTableViewCell else { return UITableViewCell() }
        cell.configureCell(model: todosLoadList[indexPath.row])
        cell.presenter = presenter
        return cell
    }
    
}

//MARK: - TableViewDelegate
extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


// MARK: - TodosViewProtocol
extension TodosViewController: TodosViewProtocol {
    func prepareDataForCells(todos: [TodoCellData]) {
        todosLoadList = todos
        reloadTableView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.todoTableView.reloadData()
        }
    }
}
