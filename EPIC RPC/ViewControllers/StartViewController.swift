//
//  StartViewController.swift
//  EPIC RPC
//
//  Created by Vladimir Dmitriev on 13.06.24.
//

import UIKit
import SnapKit

final class StartViewController: UIViewController {
    
    //Background
    private let backgroundView = UIView()
    
    // Gear / Ask
    private let gearButton = UIButton(type: .system)
    private let askButton = UIButton(type: .system)
    private let gearAndAskStack = UIStackView()
    
    // Hands / EPIC RPS
    private let maleRockHandImage = UIImageView()
    private let femaleScissorsHandImage = UIImageView()
    
    private let topicName: UILabel = {
        let label = CustomLabelFactory(text: "EPIC RPS", fontSize: 30, color: .customLightBeige)
        return label.creatLabel()
    }()
    
    
    // Start / Results
    private let startButton: UIButton = {
        let button = CustomButtonFactory(text: "START")
        return button.createButton()
    } ()
    
    private let resultsButton: UIButton = {
        let button = CustomButtonFactory(text: "RESULTS")
        return button.createButton()
    } ()
    
    private let startAndResultsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addTargetAction()
        setupConstraints()
    }
    
    //MARK: - SETTINGS
    
    private func setupViews() {
        
        backgroundView.backgroundColor = UIColor(red: 245, green: 247, blue: 251, alpha: 1)
        
        // кнопки Gear и Ask
        if let gearImage = UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal) {
            gearButton.setImage(gearImage, for: .normal)
        }
        
        if let askImage = UIImage(named: "ask")?.withRenderingMode(.alwaysOriginal) {
            askButton.setImage(askImage, for: .normal)
        }
        
        //Gear and Ask stack
        gearAndAskStack.axis = .horizontal
        gearAndAskStack.distribution = .fillEqually
        gearAndAskStack.spacing = 250
        
        // Добавляем кнопки в gearAndAskStack
        gearAndAskStack.addArrangedSubview(gearButton)
        gearAndAskStack.addArrangedSubview(askButton)
        
        //Male hand
        maleRockHandImage.image = UIImage(named: "maleHandright")
        
        // EPIC RPS label settings
        topicName.textAlignment = .center
        topicName.layer.shadowColor = #colorLiteral(red: 0.7163066268, green: 0.4840804338, blue: 0.3874616623, alpha: 1)
        topicName.layer.shadowOpacity = 1
        topicName.layer.shadowOffset = CGSize(width: 3, height: 2)
        topicName.layer.shadowRadius = 1
        
        // Female hand
        femaleScissorsHandImage.image = UIImage(named: "femaleHandleft")
        
        // Настройка кнопок Start и Results
        startButton.layer.masksToBounds = false
        startButton.configuration?.cornerStyle = .capsule
        startButton.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        
        resultsButton.layer.masksToBounds = false
        resultsButton.configuration?.cornerStyle = .capsule
        resultsButton.configuration?.attributedTitle?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))

        // Настройка startAndResultsStackview
        startAndResultsStack.axis = .vertical
        startAndResultsStack.spacing = 20
        startAndResultsStack.distribution = .fillEqually
        
        // Добавляем кнопки в startAndResultsStack
        startAndResultsStack.addArrangedSubview(startButton)
        startAndResultsStack.addArrangedSubview(resultsButton)
        
        // Добавляем все в главное view
        view.addSubview(backgroundView)
        view.addSubview(gearAndAskStack)
        view.addSubview(maleRockHandImage)
        view.addSubview(topicName)
        view.addSubview(femaleScissorsHandImage)
        view.addSubview(startAndResultsStack)
        
    }
    
    private func addTargetAction() {
        askButton.addTarget(
            self,
            action: #selector(showVC(_:)),
            for: .touchUpInside
        )
        startButton.addTarget(
            self,
            action: #selector(showVC(_:)),
            for: .touchUpInside
        )
    }
    
    @objc func showVC(_ sender: UIButton) {
        switch sender {
        case askButton:
            navigationController?.pushViewController(RulesViewController(), animated: true)
        case startButton:
            navigationController?.pushViewController(LoadViewController(), animated: true)
        default:
            break
        }
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Gear / Ask
        gearAndAskStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        //MaleRock hand
        maleRockHandImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview()//.inset(50)
            make.bottom.equalTo(topicName.snp.top).inset(-30)
            make.width.equalTo(230)
        }
        
        // Topic name
        topicName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(110)
            make.width.equalTo(250)
        }
        
        //FemaleScissors hand
        femaleScissorsHandImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(topicName.snp.bottom).inset(-30)
            make.width.equalTo(230)
            
        }
        
        // настройка и привязка stackview с кнопками start и results
        startAndResultsStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(110)
            make.width.equalTo(200)
        }
    }
}

#Preview("StartVC", body: {
    StartViewController()
})
