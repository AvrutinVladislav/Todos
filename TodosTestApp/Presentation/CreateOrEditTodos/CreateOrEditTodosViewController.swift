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
    func prepareTodoTextForEdit(model: TodoCellData) 
}

final class CreateOrEditTodosViewController: UIViewController {
    
    // MARK: - Public properties
    var presenter: CreateOrEditTodosPresenterProtocol?
    var onFinish: ((_ id: Int64) -> Void)?
    var model: TodoCellData?
    var state = CreateOrEditTodosState.edit
    
    //MARK: - UI
    private let textView = UITextView()
    private let saveButton = UIButton()
    private let backButton = UIButton()
    private let topButtonsView = UIView()
    private let titleTextField = UITextField()
    private let dateLabel = UILabel()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        addConstraints()
        presenter?.viewDidLoad(todoId: Int64(model?.item.todoId ?? 0),
                               title: model?.title,
                               state: state)
    }
}

// MARK: - Private functions
private extension CreateOrEditTodosViewController {
    func setupUI() {
        navigationItem.hidesBackButton = true
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        backButton.setImage(UIImage(resource: .chevron), for: .normal)
        backButton.setTitle("  Назад", for: .normal)
        backButton.setTitleColor(UIColor(resource: .iconYellow), for: .normal)
        backButton.tintColor = .iconYellow
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        textView.backgroundColor = .black
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        textView.textColor = .completeTodo
        textView.text = "Введите описание"
        
        titleTextField.textColor = .white
        titleTextField.font = .systemFont(ofSize: 34)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите заголовок",
            attributes: [.strokeColor: UIColor(resource: .completeTodo)]
        )
        
        dateLabel.textColor = .completeTodo
        dateLabel.font = .systemFont(ofSize: 12)
    }
    
    func addSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(topButtonsView)
        view.addSubview(textView)
        view.addSubview(dateLabel)
        topButtonsView.addSubview(backButton)
//        topButtonsView.addSubview(saveButton)
    }
    
    func addConstraints() {
        topButtonsView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: nil,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              size: CGSizeMake(view.frame.width, 40))
        
//        saveButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
//                          leading: nil,
//                          bottom: nil,
//                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
//                          padding: .init(top: 5, left: 0, bottom: -10, right: -10))
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 5, left: 10, bottom: 0, right: 0))
        
        titleTextField.anchor(top: topButtonsView.bottomAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 8, left: 20, bottom: 0, right: -20))
        
        dateLabel.anchor(top: titleTextField.bottomAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: nil,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 0, left: 20, bottom: 0, right: -20))
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textView.anchor(top: dateLabel.bottomAnchor,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 16, left: 20, bottom: -10, right: -20))
    }
    
    func convertDateToStrng(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    @objc func backButtonDidTap() {
        if let model,
           titleTextField.text != model.title ||
           textView.text != model.item.todo {
            showAlert(title: "Do you want to save changes", message: "")
        }
        presenter?.backButtonDidTap()
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
    
    func prepareTodoTextForEdit(model: TodoCellData) {
        textView.text = model.item.todo
        textView.textColor = textView.text == "Введите описание" ? .completeTodo : .white
        dateLabel.text = convertDateToStrng(date: model.date)
        titleTextField.text = model.title
    }
    
}

// MARK: - UITextViewDelegate
extension CreateOrEditTodosViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .white
        if textView.text == "Введите описание" {
            textView.text = ""
        }
    }
}
    
