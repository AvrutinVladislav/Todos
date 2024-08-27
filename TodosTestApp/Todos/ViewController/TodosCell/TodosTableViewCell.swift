//
//  TodosTableViewCell.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 26.08.2024.
//

import Foundation
import UIKit

final class TodosTableViewCell: UITableViewCell {
    
    static let identifier = "todoCell"
    
    // MARK: - private properties
    private let todoTextView = UITextView()
    private let completeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: Todo) {
        todoTextView.text = model.todo
        if model.isCompleted {
            completeLabel.textColor = .green
            completeLabel.text = "completed"
        } else {
            completeLabel.textColor = .red
            completeLabel.text = "not completed"
        }
        completeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        completeLabel.textAlignment = .center
    }
}

private extension TodosTableViewCell {
    func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 10
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        todoTextView.textColor = .black
        todoTextView.font = .systemFont(ofSize: 15)
        todoTextView.isScrollEnabled = false
        todoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        completeLabel.translatesAutoresizingMaskIntoConstraints = false
        completeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(todoTextView)
        stackView.addArrangedSubview(completeLabel)
        
        stackView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor,
                         leading: contentView.safeAreaLayoutGuide.leadingAnchor,
                         bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                         trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 10, left: 10, bottom: -10, right: -10))
    }
}
