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
    private let dataStore = DataStore.shared
    private var game: Game!
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "Background2"))
    
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
        let progressView = CustomProgressViewFactory(value: 1, tintColor: .customGreen, angle: -2)
        return progressView.createProgressView()
    } ()

    private let playerOneProgressView: UIProgressView = {
        let progressView = CustomProgressViewFactory(value: 0, tintColor: .customOrange, angle: 2)
        return progressView.createProgressView()
    } ()
    
    private let playerTwoProgressView: UIProgressView = {
        let progressView = CustomProgressViewFactory(value: 0, tintColor: .customOrange, angle: -2)
        return progressView.createProgressView()
    } ()
    
    private let separator: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        return uiView
    } ()
    
    private let rockButton: UIButton = {
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
    
    private var musicPlayer: AVAudioPlayer?
    
    private var countdownTimer: Timer?
    private var countdownSeconds: Int = 30
    
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
            paperButton
        )
        
        setupLayout()
        
        setupButtonAction()
        
        game = Game(playerOne: dataStore.computer, playerTwo: dataStore.player)
        
        startCountdown()
        
    }
    
    @objc func updateCountdown() {
        if countdownSeconds > 0 {
            countdownSeconds -= 1
            updateCountdownLabel()
            updateProgressView()
        } else {
            endRound()
        }
    }
    
    @objc func backToMain() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc func pauseGame() {
        navigationController?.pushViewController(ResultViewController(), animated: true)
    }
    
    @objc func actionButtonTapped(_ sender: UIButton) {
        
        switch sender {
        case rockButton:

            // timer - 1 second
            move(.rock)
        case scissorsButton:
            move(.scissors)
        case paperButton:
            move(.paper)
        default:
            playerOneHand.image = UIImage(named: "femaleHand")
            playerTwoHand.image = UIImage(named: "maleHand")
        }
    }
}

// MARK: - Private Methods
private extension RoundViewController {
    
    func setupButtonAction() {
        rockButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        scissorsButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        paperButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    func updateProgressView() {
        let progress = Float(countdownSeconds) / 30.0
        timerProgressView.setProgress(progress, animated: true)
    }
    
    func startCountdown() {
        timerLabel.text = "0:\(countdownSeconds)"
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    func updateCountdownLabel() {
        timerLabel.text = "0:\(countdownSeconds)"
    }
    
    func endRound() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        let result = game.playRound(playerOneMove: .paper, playerTwoMove: .rock)
        
        textLabel.text = "Time's up! \(result)"
        
        if game.isGameOver() {
            if let winner = game.getWinner() {
                textLabel.text = "\(winner === DataStore.shared.player ? "Player" : "Computer") wins the game!"
            }
            game.resetScores()
        }
    }
    
    func startMusic() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.volume = 0.2
                musicPlayer?.play()
            } catch {
                print("Ошибка воспроизведения музыки: \(error.localizedDescription)")
            }
        } else {
            print("Музыкальный файл не найден.")
        }
    }
    
    func move(_ move: Player.Move) {
        let playerOneMove = Player.Move.randomMoves()
        let playerTwoMove = move
        
        let result = game.playRound(playerOneMove: playerOneMove, playerTwoMove: playerTwoMove)
        textLabel.text = result
        
        playerOneHand.image = UIImage(named: playerOneMove.femaleHandImage)
        playerTwoHand.image = UIImage(named: playerTwoMove.maleHandImage)
        
        playerOneProgressView.setProgress(Float(dataStore.computer.score) / 3, animated: true)
        playerTwoProgressView.setProgress(Float(dataStore.player.score) / 3, animated: true)
        
        if game.isGameOver() {
            if let winner = game.getWinner() {
                print("\(winner === DataStore.shared.player ? "Player" : "Computer") wins the game!")
            }
            game.resetScores()
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
        
        let backImage = UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(backToMain)
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
    }
}

