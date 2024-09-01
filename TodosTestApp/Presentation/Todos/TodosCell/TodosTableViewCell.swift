//
//  TodosTableViewCell.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 26.08.2024.
//

import Foundation
import UIKit

final class TodosTableViewCell: UITableViewCell {
    
    weak var presenter: TodosPresenterProtocol?

    static let identifier = "todoCell"
    
    // MARK: - private properties
    private var model: TodoCellData?
    
    //MARK: - UI
    private let todoTextView = UITextView()
    private let completeButton = CustomButton()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: TodoCellData) {
        self.model = model
        todoTextView.text = model.item.todo
        if model.item.isCompleted {
            completeButton.setTitleColor(.green, for: .normal)
            completeButton.setTitle("completed", for: .normal)
        } else {
            completeButton.setTitleColor(.red, for: .normal)
            completeButton.setTitle("not completed", for: .normal)
        }
        dateLabel.text = convertDateToStrng(date: model.date)
        selectionStyle = .none
    }
}

private extension TodosTableViewCell {
    func setupUI() {
        let content = UIView()
        content.layer.borderWidth = 1
        content.layer.cornerRadius = 10
        
        todoTextView.textColor = .black
        todoTextView.font = .systemFont(ofSize: 15)
        todoTextView.isScrollEnabled = false
        todoTextView.textAlignment = .center
        todoTextView.isUserInteractionEnabled = false
        
        completeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        completeButton.isUserInteractionEnabled = true
        completeButton.addTarget(self, action: #selector(completedButtonDidTap), for: .touchUpInside)
        
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.textAlignment = .center
        
        contentView.addSubview(content)
        content.addSubview(todoTextView)
        content.addSubview(dateLabel)
        content.addSubview(completeButton)
        
        content.anchor(top: contentView.safeAreaLayoutGuide.topAnchor,
                       leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                       bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                       trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                       padding: .init(top: 10, left: 10, bottom: -5, right: -10))
        
        todoTextView.anchor(top: content.safeAreaLayoutGuide.topAnchor,
                            leading: content.safeAreaLayoutGuide.leadingAnchor,
                            bottom: content.safeAreaLayoutGuide.bottomAnchor,
                            trailing: nil,
                            padding: .init(top: 5, left: 5, bottom: -5, right: 0))
        
        dateLabel.anchor(top: content.safeAreaLayoutGuide.topAnchor,
                         leading: todoTextView.trailingAnchor,
                         bottom: nil,
                         trailing: content.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 5, left: 5, bottom: 0, right: -5))
        
        completeButton.anchor(top: dateLabel.bottomAnchor,
                             leading: todoTextView.trailingAnchor,
                             bottom: content.safeAreaLayoutGuide.bottomAnchor,
                             trailing: content.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 5, left: 5, bottom: -5, right: -5))
    }
    
    func convertDateToStrng(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @objc func completedButtonDidTap() {
        presenter?.completeButtonDidTap(todo: &(model)!)
    }

}
