//
//  LoadView.swift
//  EPIC RPC
//
//  Created by Дмитрий Волков on 13.06.2024.
//

import UIKit

class LoadView: UIView {
    // высота фрейма
    let frameHeight: CGFloat = UIScreen .main.bounds.size.height
    
    init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    func setupUI(){
        createBackgroundImageView()
        setVcImage()
        createPlayerStackView(imageName: "player1", labelText: "10 victories / 2 lose", yValue: frameHeight * 0.18)
        createPlayerStackView(imageName: "player2", labelText: "15 victories / 1 lose", yValue: frameHeight * 0.64)
        createGetReady()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoadView {
    
    // создаем фон приложения
    private func createBackgroundImageView(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Background1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // функция для инициализации любого изображения
    private func createImage(_ name: String) -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        return imageView
    }
    
    // инициализируем изображение VC и позиционируем его
    private func setVcImage(){
        let imageView = createImage("vs")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // создаем фнкцию по созданию стека для изображения игрока и статистики и его позиционированием
    private func createPlayerStackView(imageName: String, labelText: String, yValue: CGFloat){
        // настраиваем StackView
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.center = center
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        // создаем изображение Игрока и его статистику
        let imageView = createImage(imageName)
        let label = createPlayerStat(labelText)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        // позиционируем StackView
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: yValue).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // содаем статистику для игрока
    private func createPlayerStat(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
    // создаем и позиционируем кнопку Get Ready
    private func createGetReady(){
        let label = UILabel()
        label.text = "Get ready..."
        label.textColor = .systemYellow
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    }

}
