//
//  RulesViewController.swift
//  EPIC RPC
//
//  Created by Vladimir Dmitriev on 13.06.24.
//

import UIKit

final class RulesViewController: UIViewController {
    let rules = [Rule(text: "Игра проводится между игроком и компьютером.", image: "rule1", subpoint: false),
                 Rule(text: "Жесты:", image: "rule2", subpoint: false),
                 Rule(text: "Кулак > Ножницы", image: "Scissors", subpoint: true),
                 Rule(text: "Бумага > Кулак", image: "Stone", subpoint: true),
                 Rule(text: "Ножницы > Бумага", image: "Paper", subpoint: true),
                 Rule(text: "У игрока есть 30 сек. для выбора жеста.", image: "rule3", subpoint: false),
                 Rule(text: "Игра ведется до трех побед одного из участников.", image: "rule4", subpoint: false),
                 Rule(text: "За каждую победу игрок получает 500 баллов, которые можно посмотреть на доске лидеров.", image: "rule5", subpoint: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        createHeading()
        setRules()
        
    }

}

extension RulesViewController {
    
    private func createHeading(){
        let label = UILabel()
        
        label.text = "Rules"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    // функция для инициализации любого изображения
    private func createImage(_ name: String) -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        return imageView
    }
    
    // функция для создания одного правила
    private func createRuleText (_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
    private func createRuleStackView(imageName: String, labelText: String, subpoint: Bool) -> UIStackView {
        let stackView = UIStackView()
        //addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        // создаем значок-номер и правило
        let imageView = createImage(imageName)
        let label = createRuleText(labelText)
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        
        
        return stackView
    }
    
    func setRules(){
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        for rule in rules {
            let rule = createRuleStackView(imageName: rule.image, labelText: rule.text, subpoint: rule.subpoint)
            stackView.addArrangedSubview(rule)
        }
        
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
    }
}

extension RulesViewController {
    struct Rule {
        let text: String
        let image: String
        let subpoint: Bool
    }
}



