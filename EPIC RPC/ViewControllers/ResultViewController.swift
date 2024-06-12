//
//  ResultViewController.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 12.06.24.
//

import UIKit

final class ResultViewController: UIViewController {

    private let backgroundImageView = UIImageView(image: UIImage(named: "Background1"))
    
    private let circleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.layer.cornerRadius = view.frame.width / 2
        view.backgroundColor = .customBlue
        return view
    } ()

    private let playerImage = UIImageView(image: UIImage(named: "player1"))
    
    private let resultLabel: UILabel = {
        let label = CustomLabelFactory(text: "You Win", fontSize: 18, color: .customOrange)
        return label.creatLabel()
    } ()
    
    private let scoreLabel: UILabel = {
        let label = CustomLabelFactory(text: "3 - 1", fontSize: 40, color: .white)
        return label.creatLabel()
    } ()
    
    private let homeButton: UIButton = {
        let button = CustomButtonFactory(image: "homeIcon")
        return button.createButton()
    } ()
    
    private let repeatButton: UIButton = {
        let button = CustomButtonFactory(image: "repeatIcon")
        return button.createButton()
    } ()
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupbuttonsStackView()
        
        setupSubview(
            backgroundImageView,
            circleView,
            playerImage,
            resultLabel,
            scoreLabel,
            stackView
        )
        
        setupLayout()
        
    }

}

private extension ResultViewController {
    
    func setupbuttonsStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(repeatButton)
    }
    
    func setupSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setupLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
            make.width.height.equalTo(150)
        }
        
        playerImage.snp.makeConstraints { make in
            make.center.equalTo(circleView)
            make.width.equalTo(60)
            make.height.equalTo(70)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(circleView.snp.centerX)
            make.top.equalTo(circleView.snp.bottom).offset(30)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(resultLabel)
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
        }
        
        homeButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(50)
        }
        
        repeatButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreLabel.snp.bottom).offset(30)
        }
    }
    
}
