//
//  CustomSearchBar.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 06.12.2024.
//

import UIKit

final class CustomSearchBar : UIView {
    
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Введите текст"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal

        let textField = searchBar.searchTextField
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let leftIconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftIconView.tintColor = .gray
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        leftIconView.center = leftView.center
        leftView.addSubview(leftIconView)
        textField.leftView = leftView
        
        let microphoneButton = UIButton(type: .system)
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        microphoneButton.tintColor = .gray
        microphoneButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        microphoneButton.center = rightView.center
        rightView.addSubview(microphoneButton)
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    
    @objc private func microphoneTapped() {
           print("Микрофон нажат")
       }
}

extension CustomSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Текст поиска: \(searchText)")
        }
}
