//
//  RoundedButtonFactory.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 11.06.24.
//

import UIKit

protocol ButtonFactory {
    func createButton() -> UIButton
}

final class RoundedButtonFactory: ButtonFactory {

    let image: String
    let color: UIColor
    let offset: Double

    init(image: String, color: UIColor, offset: Double) {
        self.image = image
        self.color = color
        self.offset = offset
    }

    func createButton() -> UIButton {
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.cornerStyle = .capsule
        buttonConfiguration.image = UIImage(named: image)
        buttonConfiguration.background.backgroundColor = color
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(
            top: offset,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        let button = UIButton(configuration: buttonConfiguration)
        
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.alpha = 1
            default:
                button.alpha = 0.6
            }
        }
        
        return button
    }
}
