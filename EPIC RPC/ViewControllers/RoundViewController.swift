//
//  RoundViewController.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 11.06.24.
//

import UIKit
import SnapKit
import AVFoundation

final class RoundViewController: UIViewController {
    
    // MARK: - Private Properties
    private var backgroundImageView = UIImageView(image: UIImage(named: "Background2"))
    
    private let playerOneHand = UIImageView(image: UIImage(named: "femaleHand"))
    private let playerTwoHand = UIImageView(image: UIImage(named: "maleHand"))
    
    private let playerOneImage = UIImageView(image: UIImage(named: "player1"))
    private let playerTwoImage = UIImageView(image: UIImage(named: "player2"))
    
    private let textLabel: UILabel = {
        let text = CustomLabelFactory(text: "FIGHT", fontSize: 50, color: .customOrange)
        return text.creatLabel()
    } ()
    
    private let timerLabel: UILabel = {
        let label = CustomLabelFactory(text: "0:30", fontSize: 16, color: .white)
        return label.creatLabel()
    } ()
 
    private let timerProgressView: UIProgressView = {
        let progressView = CustomProgressViewFactory(tintColor: .customGreen, angle: -2)
        return progressView.createProgressView()
    } ()

    private let playerOneProgressView: UIProgressView = {
        let progressView = CustomProgressViewFactory(tintColor: .customOrange, angle: 2)
        return progressView.createProgressView()
    } ()
    
    private let playerTwoProgressView: UIProgressView = {
        let progressView = CustomProgressViewFactory(tintColor: .customOrange, angle: -2)
        return progressView.createProgressView()
    } ()
    
    private let separator: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        return uiView
    } ()
    
    private lazy var rockButton: UIButton = {
        let button = RoundedButtonFactory(image: "rockIcon", color: .customBlue, offset: 0)
        return button.createButton()
    } ()
    
    private let scissorsButton: UIButton = {
        let button = RoundedButtonFactory(image: "scissorsIcon", color: .customBlue, offset: 0)
        return button.createButton()
    } ()
    
    private let paperButton: UIButton = {
        let button = RoundedButtonFactory(image: "paperIcon",color: .customBlue, offset: 0)
        return button.createButton()
    } ()
    
    private let randomButton: UIButton = {
        let button = RoundedButtonFactory(image: "randomIcon",color: .customBlue, offset: -50)
        return button.createButton()
    } ()
    
    private var musicPlayer: AVAudioPlayer?
    
    var player = Player.getPlayer()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startMusic()
        
        setupNavigationBar()
        setupTimerProgressView()
        
        setupSubview(
            backgroundImageView,
            textLabel,
            playerOneHand,
            playerTwoHand,
            timerProgressView,
            timerLabel,
            playerOneProgressView,
            playerTwoProgressView,
            playerOneImage,
            playerTwoImage,
            separator,
            rockButton,
            scissorsButton,
            paperButton,
            randomButton
        )
        
        setupLayout()
        
        rockButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        scissorsButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        paperButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillLayoutSubviews() {
        rockButton.layer.cornerRadius = rockButton.frame.width / 2
        scissorsButton.layer.cornerRadius = scissorsButton.frame.width / 2
        paperButton.layer.cornerRadius = paperButton.frame.width / 2
        randomButton.layer.cornerRadius = randomButton.frame.width / 2
    }
    
}

// MARK: - Private Methods
private extension RoundViewController {
    
    func startMusic() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.volume = 0.3
                musicPlayer?.play()
            } catch {
                print("Ошибка воспроизведения музыки: \(error.localizedDescription)")
            }
        } else {
            print("Музыкальный файл не найден.")
        }
    }
    
    func setupNavigationBar() {
        title = "Игра"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.customGray,
            .font: UIFont.systemFont(ofSize: 24)
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearance

        let pauseImage = UIImage(systemName: "pause.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: pauseImage,
            style: .plain,
            target: self,
            action: #selector(pauseGame)
        )
        
        navigationController?.navigationBar.tintColor = UIColor.customGray
    }
    
    func setupTimerProgressView() {
        let progressPath = UIBezierPath(
            roundedRect: CGRect(
                x: 0,
                y: 0,
                width: 200,
                height: 10
            ),
            cornerRadius: 5
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = progressPath.cgPath
        timerProgressView.layer.mask = maskLayer
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
        
        textLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        playerOneHand.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-150)
            make.leading.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(200)
        }
       
        playerTwoHand.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(150)
            make.leading.equalToSuperview().inset(200)
            make.trailing.equalToSuperview().inset(50)
        }
        
        timerProgressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(-70)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(10)
        }
       
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(timerProgressView.snp.centerX)
            make.top.equalTo(timerProgressView.snp.bottom).offset(110)
        }
        
        playerOneProgressView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(-45)
            make.centerY.equalToSuperview().offset(-75)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        
        playerTwoProgressView.snp.makeConstraints { make in
            make.centerX.equalTo(playerOneProgressView.snp.centerX)
            make.centerY.equalToSuperview().offset(75)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        
        separator.snp.makeConstraints { make in
            make.centerX.equalTo(playerOneProgressView.snp.centerX)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(2)
        }
        
        playerOneImage.snp.makeConstraints { make in
            make.centerX.equalTo(playerOneProgressView.snp.centerX)
            make.bottom.equalTo(playerOneProgressView).inset(70)
            make.width.height.equalTo(30)
        }
        
        playerTwoImage.snp.makeConstraints { make in
            make.centerX.equalTo(playerOneProgressView.snp.centerX)
            make.top.equalTo(playerTwoProgressView).inset(70)
            make.width.height.equalTo(30)
        }
        
        rockButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(50)
            make.width.height.equalTo(80)
        }
        
        scissorsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.width.height.equalTo(80)
        }
        
        paperButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(50)
            make.width.height.equalTo(80)
        }
        
        randomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scissorsButton.snp.bottom).offset(20)
            make.width.height.equalTo(120)
        }
        
    }
    
    @objc func pauseGame() {
        
    }
    
    @objc func actionButtonTapped(_ sender: UIButton) {
        switch sender {
        case rockButton:
            playerTwoHand.image = UIImage(named: player.choice[0])
        case scissorsButton:
            playerTwoHand.image = UIImage(named: player.choice[1])
        case paperButton:
            playerTwoHand.image = UIImage(named: player.choice[2])
        default:
            playerTwoHand.image = UIImage(named: player.choice[3])
        }
    }
    
}

