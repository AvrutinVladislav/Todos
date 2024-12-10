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

final class TodosViewController: UIViewController {
    // MARK: - Public
    var presenter: TodosPresenterProtocol?
    
    // MARK: - Private properties
    private var todosLoadList: [TodoCellData] = []
    private var searchList: [TodoCellData] = []
    
    //MARK: - UI
    private let addTodoButton = UIButton()
    private let todoTableView = UITableView()
    private let todosCounterLabel = UILabel()
    private var searchBar = UITextField()
    private let fotterView = UIView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        addConstraints()
        presenter?.viewDidLoad()
        setupNavigationBar()
    }
    
    func getTodoFromTodosList(id: Int64) -> TodoCellData? {
        return todosLoadList.first(where: {$0.item.todoId == id})
    }
}

// MARK: - Private functions
private extension TodosViewController {
    func setupUI() {
        view.backgroundColor = .black
        setupSearchBar()
                
        fotterView.backgroundColor = UIColor(named: "footerColor")
        
        todoTableView.register(TodosTableViewCell.self, forCellReuseIdentifier: TodosTableViewCell.identifier)
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.backgroundColor = .clear
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonDidTap), for: .touchUpInside)
        addTodoButton.setImage(UIImage(named: "newTodo"), for: .normal)
        addTodoButton.contentVerticalAlignment = .fill
        addTodoButton.contentHorizontalAlignment = .fill
        addTodoButton.tintColor = .white
        
        todosCounterLabel.textColor = .white
        todosCounterLabel.font = .systemFont(ofSize: 11)
    }
    
    func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(addTodoButton)
        view.addSubview(todoTableView)
        view.addSubview(fotterView)
        fotterView.addSubview(addTodoButton)
        fotterView.addSubview(todosCounterLabel)
    }
    
    func addConstraints() {
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: nil,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: -16, right: -20))
        
        todoTableView.anchor(top: searchBar.bottomAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 10, left: 20, bottom: -49, right: -20))
        
        fotterView.anchor(top: todoTableView.bottomAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 0, left: 20, bottom: 0, right: -20))
        
        addTodoButton.anchor(top: fotterView.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: fotterView.trailingAnchor)
        
        todosCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todosCounterLabel.centerXAnchor.constraint(equalTo: fotterView.centerXAnchor),
            todosCounterLabel.centerYAnchor.constraint(equalTo: addTodoButton.centerYAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Задачи"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        navigationController?.navigationBar.barTintColor = .blue
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupSearchBar() {
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.gray]
        )
        searchBar.borderStyle = .roundedRect
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.backgroundColor = UIColor(named: "footerColor")
        searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchBar.textColor = .white

        let leftIconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftIconView.tintColor = .gray
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let leftView = UIView(frame: CGRect(x: 8, y: 0, width: 30, height: 24))
        leftIconView.center = leftView.center
        leftView.addSubview(leftIconView)
        searchBar.leftView = leftView
        searchBar.leftViewMode = .always

        let microphoneButton = UIButton(type: .system)
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        microphoneButton.tintColor = .gray
        microphoneButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: -8, y: 0, width: 30, height: 24))
        microphoneButton.center = rightView.center
        rightView.addSubview(microphoneButton)
        searchBar.rightView = rightView
        searchBar.rightViewMode = .always
    }
    
    @objc func addTodoButtonDidTap() {
        presenter?.pushCreateOrEditVC(id: nil)
    }
    
    @objc func microphoneTapped() {
        print("Микрофон нажат")
    }
    
    @objc func textFieldDidChange() {
        let searchText = searchBar.text ?? ""
        if let filterList = presenter?.filterCells(cells: todosLoadList, searchText: searchText) {
            searchList = filterList
            reloadTableView()
        }
    }
    
}

//MARK: - TableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todosCounterLabel.text = "\(searchList.count) Задач"
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodosTableViewCell.identifier, for: indexPath) as? TodosTableViewCell else { return UITableViewCell() }
        cell.configureCell(model: searchList[indexPath.row])
        cell.presenter = presenter
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        cell.tag = indexPath.row
        return cell
    }
    
}

//MARK: - TableViewDelegate
extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.pushCreateOrEditVC(id: Int64(todosLoadList[indexPath.row].item.todoId))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter?.deleteTodo(todo: todosLoadList[indexPath.row])
    }
}

// MARK: - TodosViewProtocol
extension TodosViewController: TodosViewProtocol {
    func prepareDataForCells(todos: [TodoCellData]) {
        todosLoadList = todos
        searchList = todos
        reloadTableView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.todoTableView.reloadData()
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension TodosViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = interaction.view as? TodosTableViewCell else { return nil }
        let todo = todosLoadList[cell.tag]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(resource: .edit)) { _ in
                self?.presenter?.pushCreateOrEditVC(id: Int64(todo.item.todoId))
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(resource: .trash), attributes: .destructive) { _ in
                self?.presenter?.deleteTodo(todo: todo)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
