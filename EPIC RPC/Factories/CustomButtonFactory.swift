//
//  CustomButtonFactory.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 12.06.24.
//

import UIKit

final class CustomButtonFactory: ButtonFactory {

    let text: String?
    let image: String?
    
    init(text: String? = nil, image: String? = nil) {
        self.text = text
        self.image = image
    }
    
    func createButton() -> UIButton {
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.cornerStyle = .large
        buttonConfiguration.background.backgroundColor = UIColor(
            named: "customLightBeige"
        )
        
        if let text = text {
            buttonConfiguration.title = text
            
            var textAttributes = AttributeContainer()
            
            textAttributes.font = UIFont.systemFont(
                ofSize: 24,
                weight: UIFont.Weight(rawValue: 700)
            )
            
            textAttributes.foregroundColor = UIColor(named: "customBrown")
            
            buttonConfiguration.attributedTitle = AttributedString(
                text,
                attributes: textAttributes
            )
            
        }
        
        if let image = image {
            buttonConfiguration.image = UIImage(named: image)
        }
        
        let button = UIButton(configuration: buttonConfiguration)
        
        button.layer.shadowColor = UIColor(named: "customDarkBeige")?.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.alpha = 0.6
            default:
                button.alpha = 1
            }
        }
        
        return button
    }
}

