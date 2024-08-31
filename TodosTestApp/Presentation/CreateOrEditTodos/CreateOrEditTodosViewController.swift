//
//  CreateOrEditTodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

protocol CreateOrEditTodosViewProtocol: AnyObject {
    func showAlert(title: String, message: String, firstButtonTitle: String, secondButtonTitle: String)
    func onFinished()
    func toDoId(id: Int64)
}

class CreateOrEditTodosViewController: UIViewController {
    //MARK: - Private properties
    private let textView = UITextView()
    private  let saveButton = UIButton()
    private  let backButton = UIButton()
    var onFinish: ((_ id: Int64) -> Void)?
    var todoId: Int64?
    
    // MARK: - Public properties
    var presenter: CreateOrEditTodosPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private functions
private extension CreateOrEditTodosViewController {
    func setupUI() {
        navigationItem.hidesBackButton = true
        
        let separator = UIView()
        separator.frame = .init(x: 0, y: 0, width: view.frame.width, height: 1)
        separator.backgroundColor = .white
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        view.addSubview(saveButton)
        view.addSubview(backButton)
        view.addSubview(separator)
        view.addSubview(textView)
        
        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: nil,
                          bottom: separator.topAnchor,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 5, left: 0, bottom: -10, right: -10))
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: separator.topAnchor,
                          trailing: nil,
                          padding: .init(top: 5, left: 10, bottom: -10, right: 0))
        
        separator.anchor(top: nil,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: textView.topAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        textView.anchor(top: nil,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 10, left: 10, bottom: -10, right: -10))
    }
    
    @objc func backButtonDidTap() {
        showAlert(title: "Do you want to save changes", message: "")
    }
    
    @objc func saveButtonDidTap() {
        presenter?.saveButtonDidTap(text: textView.text)
    }
}

// MARK: - CreateOrEditTodosViewProtocol
extension CreateOrEditTodosViewController: CreateOrEditTodosViewProtocol {
    
    func showAlert(title: String, message: String, firstButtonTitle: String = "No", secondButtonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: .cancel, handler: { [weak self] (action: UIAlertAction) in
            self?.presenter?.backButtonDidTap()
        }))
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: .default, handler: { [weak self] (action: UIAlertAction) in
            self?.saveButtonDidTap()
        }))
        self.present(alert, animated: true)
    }
    
    func onFinished() {
        if let todoId = todoId {
            onFinish?(todoId)
        }
    }
    
    func toDoId(id: Int64) {
        todoId = id
    }
}
