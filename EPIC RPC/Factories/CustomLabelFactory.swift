//
//  CustomLabelFactory.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 11.06.24.
//

import UIKit

protocol LabelFactory {
    func creatLabel() -> UILabel
}

final class CustomLabelFactory: LabelFactory {
    
    let text: String
    let fontSize: Double
    let color: UIColor
    
    init(text: String, fontSize: Double, color: UIColor) {
        self.text = text
        self.fontSize = fontSize
        self.color = color
    }
    
    func creatLabel() -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 700))
        label.textColor = color
        
        return label
    }
}

