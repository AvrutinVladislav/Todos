//
//  CreateOrEditTodosViewController.swift
//  Super easy dev
//
//  Created by Vladislav Avrutin on 27.08.2024
//

import UIKit

protocol CreateOrEditTodosViewProtocol: AnyObject {
    func showAlert(title: String, message: String, firstButtonTitle: String, secondButtonTitle: String)
    func onFinished(id: Int64)
    func prepareTodoTextForEdit(text: String)
}

class CreateOrEditTodosViewController: UIViewController {
    //MARK: - Private properties
    private let textView = UITextView()
    private  let saveButton = UIButton()
    private  let backButton = UIButton()
    
    // MARK: - Public properties
    var presenter: CreateOrEditTodosPresenterProtocol?
    var onFinish: ((_ id: Int64) -> Void)?
    var todoId: Int64?
    var state = CreateOrEditTodosState.edit
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad(todoId: todoId, state: state)
    }
}

// MARK: - Private functions
private extension CreateOrEditTodosViewController {
    func setupUI() {
        navigationItem.hidesBackButton = true
        
        let topButtonsView = UIView()
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 20)
        
        view.addSubview(topButtonsView)
        view.addSubview(textView)
        topButtonsView.addSubview(backButton)
        topButtonsView.addSubview(saveButton)
        
        topButtonsView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              size: CGSizeMake(view.frame.width, 40))
        
        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 5, left: 0, bottom: -10, right: -10))
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 5, left: 10, bottom: -10, right: 0))
        
        textView.anchor(top: topButtonsView.bottomAnchor,
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
    
    func onFinished(id: Int64) {
        onFinish?(id)
    }
    
    func prepareTodoTextForEdit(text: String) {
        textView.text = text
    }
    
}
