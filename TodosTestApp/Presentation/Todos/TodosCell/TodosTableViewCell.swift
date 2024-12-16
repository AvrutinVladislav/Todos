//
//  TodosTableViewCell.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 26.08.2024.
//

import Foundation
import UIKit

final class TodosTableViewCell: UITableViewCell {
    
    //MARK: - Public properties
    weak var presenter: TodosPresenterProtocol?

    static let identifier = "todoCell"
    
    // MARK: - Private properties
    private var model: TodoCellData?
    
    //MARK: - UI
    private let titleLabel = UILabel()
    private let todoTextView = UITextView()
    private let completeButton = CustomButton()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.textColor = .white
        titleLabel.attributedText = NSAttributedString(
            string: ""
        )
        todoTextView.textColor = .white
    }
    
    func configureCell(model: TodoCellData) {
        self.model = model
        todoTextView.text = model.item.todo
        if model.item.isCompleted {
            titleLabel.attributedText = NSAttributedString(
                string: model.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.textColor = .completeTodo
            todoTextView.textColor = .completeTodo
            completeButton.setImage(UIImage(resource: .completedTodo), for: .normal)
        } else {
            titleLabel.textColor = .white
            titleLabel.text = model.title
            todoTextView.textColor = .white
            completeButton.setImage(UIImage(resource: .notCompletedTodo), for: .normal)
        }
        dateLabel.text = convertDateToStrng(date: model.date)
        selectionStyle = .none
    }
}

private extension TodosTableViewCell {
    func setupUI() {
        contentView.backgroundColor = .black
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        todoTextView.textColor = .white
        todoTextView.backgroundColor = .black
        todoTextView.font = .systemFont(ofSize: 12)
        todoTextView.isScrollEnabled = false
        todoTextView.showsVerticalScrollIndicator = false
        todoTextView.showsHorizontalScrollIndicator = false
        todoTextView.isUserInteractionEnabled = false
        
        completeButton.isUserInteractionEnabled = true
        completeButton.addTarget(self, action: #selector(completedButtonDidTap), for: .touchUpInside)
        
        dateLabel.textColor = .completeTodo
        dateLabel.font = .systemFont(ofSize: 12)
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(todoTextView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(completeButton)
    }
    
    func addConstraints() {
        completeButton.anchor(top: contentView.safeAreaLayoutGuide.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: nil,
                              trailing: nil,
                              padding: .init(top: 12, left: 20, bottom: 0, right: 0),
                              size: .init(width: 24, height: 24))
        
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        titleLabel.anchor(top: contentView.safeAreaLayoutGuide.topAnchor,
                          leading: completeButton.trailingAnchor,
                          bottom: nil,
                          trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 12, left: 8, bottom: 0, right: -20))
        
        todoTextView.anchor(top: titleLabel.bottomAnchor,
                            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                            bottom: nil,
                            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                            padding: .init(top: 6, left: 52, bottom: 0, right: -20))
        
        dateLabel.anchor(top: todoTextView.bottomAnchor,
                         leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                         bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                         trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 6, left: 52, bottom: -10, right: 0))
    }
    
    func convertDateToStrng(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    @objc func completedButtonDidTap() {
        presenter?.completeButtonDidTap(todo: &(model)!)
    }

}
