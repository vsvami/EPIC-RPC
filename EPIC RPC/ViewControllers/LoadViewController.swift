//
//  LoadViewController.swift
//  EPIC RPC
//
//  Created by Vladimir Dmitriev on 13.06.24.
//

import UIKit

final class LoadViewController: UIViewController {

    let frameHeight: CGFloat = UIScreen.main.bounds.size.height
    let dataStore = DataStore.shared

    private let winsOfPlayerOneLabel: UILabel = {
        let label = CustomLabelFactory(text: "0", fontSize: 24, color: .customOrange)
        return label.creatLabel()
    } ()
    
    private let lossesOfPlayerOneLabel: UILabel = {
        let label = CustomLabelFactory(text: "0", fontSize: 24, color: .customRed)
        return label.creatLabel()
    } ()
    
    private let winsOfPlayerTwoLabel: UILabel = {
        let label = CustomLabelFactory(text: "0", fontSize: 24, color: .customOrange)
        return label.creatLabel()
    } ()
    
    private let lossesOfPlayerTwoLabel: UILabel = {
        let label = CustomLabelFactory(text: "0", fontSize: 24, color: .customRed)
        return label.creatLabel()
    } ()
    
    
    
    private let vsLabel: UILabel = {
        let label = CustomLabelFactory(text: "VS", fontSize: 50, color: .customOrange)
        return label.creatLabel()
    } ()
    
    private let getReadyLabel: UILabel = {
        let label = CustomLabelFactory(text: "Get ready...", fontSize: 20, color: .customOrange)
        return label.creatLabel()
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToResultVC()
        }
    }
    
    func navigateToResultVC() {
        navigationController?.pushViewController(RoundViewController(), animated: true)
    }
    
    func setupUI(){
        createBackgroundImageView()
        setupVSLabel()
        createGetReady()
        
        createPlayerStackView(
            imageName: "player1",
            winLabel: winsOfPlayerOneLabel,
            winLabelText: "\(dataStore.computer.wins)",
            lossLabel: lossesOfPlayerOneLabel,
            loseLabelText: "\(dataStore.computer.losses)",
            yValue: frameHeight * 0.18
        )
        

        createPlayerStackView(
            imageName: "player2",
            winLabel: winsOfPlayerTwoLabel,
            winLabelText: "\(dataStore.player.wins)",
            lossLabel: lossesOfPlayerTwoLabel,
            loseLabelText: "\(dataStore.player.losses)",
            yValue: frameHeight * 0.64
        )
        
        setupVSLabel()
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
    
    // инициализируем VS и позиционируем его
    private func setupVSLabel() {
        view.addSubview(vsLabel)
        
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func createPlayerStackView(
        imageName: String,
        winLabel: UILabel,
        winLabelText: String,
        lossLabel: UILabel,
        loseLabelText: String,
        yValue: CGFloat
    ){
        // настраиваем StackView
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.center = view.center
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        // создаем изображение Игрока и его статистику
        let victoriesLabel: UILabel = {
            let label = CustomLabelFactory(text: "Victories", fontSize: 24, color: .white)
            return label.creatLabel()
        } ()
        
        let loseLabel: UILabel = {
            let label = CustomLabelFactory(text: "Lose", fontSize: 24, color: .white)
            return label.creatLabel()
        } ()
        
        let winsStackView = UIStackView()
        winLabel.text = winLabelText
        winsStackView.translatesAutoresizingMaskIntoConstraints = false
        winsStackView.axis = .horizontal
        winsStackView.spacing = 5
        winsStackView.center = view.center
        winsStackView.alignment = .center
        winsStackView.distribution = .equalSpacing
        winsStackView.addArrangedSubview(winLabel)
        winsStackView.addArrangedSubview(victoriesLabel)
        
        let loseStackView = UIStackView()
        lossLabel.text = loseLabelText
        loseStackView.translatesAutoresizingMaskIntoConstraints = false
        loseStackView.axis = .horizontal
        loseStackView.spacing = 5
        loseStackView.center = view.center
        loseStackView.alignment = .center
        loseStackView.distribution = .equalSpacing
        loseStackView.addArrangedSubview(lossLabel)
        loseStackView.addArrangedSubview(loseLabel)
        
        let imageView = createImage(imageName)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(winsStackView)
        stackView.addArrangedSubview(loseStackView)
        
        // позиционируем StackView
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: yValue).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // создаем и позиционируем кнопку Get Ready
    private func createGetReady(){
        getReadyLabel.textAlignment = .center
        getReadyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(getReadyLabel)
        
        getReadyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        getReadyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        getReadyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }

}

#Preview("StartVC", body: {
    LoadViewController()
})
