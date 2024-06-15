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
    
    private var audioPlayer: AVAudioPlayer?
    private var clickPlayer: AVAudioPlayer?
    
    private var timer: Timer?
    private var timeRemaining: Int = 30
    private var isPaused: Bool = false
    
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
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = Game(playerOne: dataStore.computer, playerTwo: dataStore.player)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        game.resetScores()
        setupAudioPlayer()
        startNewRound()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopMusic()
        timer?.invalidate()
    }
    
    // MARK: - Actions
    @objc func backToMain() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc func pauseGame() {
        if isPaused {
            resumeTimer()
            textLabel.text = ""
        } else {
            pauseTimer()
            textLabel.text = "PAUSE"
        }
        isPaused.toggle()
    }
    
    @objc func playerTwoMoveSelected(_ sender: UIButton) {
        playClickSound()
        
        rockButton.isEnabled = false
        scissorsButton.isEnabled = false
        paperButton.isEnabled = false
        
        let playerOneMove = Player.Move.randomMoves()
        let playerTwoMove = determineMove(from: sender)

        let result = game.playRound(playerOneMove: playerOneMove, playerTwoMove: playerTwoMove)
        
        timer?.invalidate()
        
        sender.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.handleRoundResult(result)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            if self?.game.isGameOver() == false {
                self?.startNewRound()
            }
        }
    }
    
    @objc func updateTime() {
        timeRemaining -= 1
        updateTimerLabel()
        updateTimerProgressView()
        if timeRemaining <= 0 {
            timer?.invalidate()
            endRoundDueToTimeout()
        }
    }
}

// MARK: - Private Methods
private extension RoundViewController {
    
    // MARK: - Setup Audio
    func playClickSound() {
        if let url = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            do {
                clickPlayer = try AVAudioPlayer(contentsOf: url)
                clickPlayer?.volume = 1
                clickPlayer?.play()
            } catch {
                print("Ошибка воспроизведения клика: \(error.localizedDescription)")
            }
        } else {
            print("Файл звука клика не найден.")
        }
    }
    
    func setupAudioPlayer() {
        if let url = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.volume = 0.3
                audioPlayer?.play()
            } catch {
                print("Ошибка воспроизведения музыки: \(error.localizedDescription)")
            }
        } else {
            print("Музыкальный файл не найден.")
        }
    }
    
    private func playMusic() {
        audioPlayer?.play()
    }
    
    private func pauseMusic() {
        audioPlayer?.pause()
    }
    
    private func stopMusic() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    // MARK: - Setup Timer
    func pauseTimer() {
        timer?.invalidate()
        pauseMusic()
    }
    
    func resumeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        playMusic()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timeRemaining = 30
        updateTimerLabel()
        updateTimerProgressView()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    // MARK: - Update UI
    func updateUIForNewRound() {
        updatePlayersHand()
        updatePlayersProgress()
        
        updateTimerLabel()
        updateTimerProgressView()
    }
    
    func updatePlayersHand() {
        let image = dataStore.computer.currentMove.femaleHandImage
        let image2 = dataStore.player.currentMove.maleHandImage
    
        playerOneHand.image = UIImage(named: image)
        playerTwoHand.image = UIImage(named: image2)
    }
    
    func updatePlayersProgress() {
        let playerOneScore = dataStore.computer.score
        playerOneProgressView.progress = Float(playerOneScore) / 3
        
        let playerTwoScore = dataStore.player.score
        playerTwoProgressView.progress = Float(playerTwoScore) / 3
    }
    
    func updateTimerLabel() {
        timerLabel.text = "0:\(timeRemaining)"
    }
    
    func updateTimerProgressView() {
        let progress = Float(timeRemaining) / 30.0
        timerProgressView.setProgress(progress, animated: true)
    }
    
    // MARK: - Game
    func startNewRound() {
        rockButton.isEnabled = true
        scissorsButton.isEnabled = true
        paperButton.isEnabled = true
        
        game.startRound()
        resetTimer()
        updateUIForNewRound()
        print("\(dataStore.player.score) - \(dataStore.computer.score)")
    }
    
    func determineMove(from button: UIButton) -> Player.Move {
        switch button {
        case rockButton:
            return Player.Move.rock
        case scissorsButton:
            return Player.Move.scissors
        case paperButton:
            return Player.Move.paper
        default:
            return Player.Move.ready
        }
    }
    
    func endRoundDueToTimeout() {
        game.endRoundDueToTimeout()
        handleRoundResult("")
        startNewRound()
    }
    
    func handleRoundResult(_ result: String) {
        textLabel.text = result == "DRAW" ? "DRAW" : result
        
        if game.isGameOver() {
            let winner = game.getWinner()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.navigationController?.pushViewController(ResultViewController(), animated: true)
            }
            
        } else {
            updateUIForNewRound()
        }
    }
    
    // MARK: - Setup UI
    func setupButtonAction() {
        rockButton.addTarget(self, action: #selector(playerTwoMoveSelected), for: .touchUpInside)
        scissorsButton.addTarget(self, action: #selector(playerTwoMoveSelected), for: .touchUpInside)
        paperButton.addTarget(self, action: #selector(playerTwoMoveSelected), for: .touchUpInside)
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

