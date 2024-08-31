//
//  Button+Extension.swift
//  TodosTestApp
//
//  Created by Vladislav Avrutin on 30.08.2024.
//

import UIKit

final class CustomButton: UIButton {
    
    private let hitAreaInsets = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.inset(by: hitAreaInsets).contains(point)
    }
}
