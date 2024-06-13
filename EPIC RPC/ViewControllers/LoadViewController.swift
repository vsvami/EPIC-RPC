//
//  LoadViewController.swift
//  EPIC RPC
//
//  Created by Vladimir Dmitriev on 13.06.24.
//

import UIKit

final class LoadViewController: UIViewController {

    let frameHeight: CGFloat = UIScreen .main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToResultVC()
        }
    }
    
    func navigateToResultVC() {
        navigationController?.pushViewController(RoundViewController(), animated: true)
    }
    
    func setupUI(){
        createBackgroundImageView()
        setVcImage()
        createPlayerStackView(imageName: "player1", labelText: "10 victories / 2 lose", yValue: frameHeight * 0.18)
        createPlayerStackView(imageName: "player2", labelText: "15 victories / 1 lose", yValue: frameHeight * 0.64)
        createGetReady()
    }
}


extension LoadViewController {
    
    // создаем фон приложения
    private func createBackgroundImageView(){
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Background1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // создаем фнкцию по созданию стека для изображения игрока и статистики и его позиционированием
    private func createPlayerStackView(imageName: String, labelText: String, yValue: CGFloat){
        // настраиваем StackView
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.center = view.center
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
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: yValue).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
        view.addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }

}

#Preview("StartVC", body: {
    LoadViewController()
})
