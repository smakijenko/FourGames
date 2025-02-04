//
//  RunGameScene.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 18/11/2024.
//

import Foundation
import UIKit
import SpriteKit

var runColor: String = ""

class RunGameScene: SKScene, GameButtonDelegate {
    weak var runVm: RunViewModel?
    private let ground: RunGround
    private let kangaroo: Kangaroo
    private let obstacles: Obstacles
    private let button: GameButton
    private let scoreLabel: ScoreLabel
    private let ugIcons: UndergroundIcons
    
    private let startSpeed: Int = 6
    private var movingSpeed: CGFloat
    private var isGameOn: Bool = false
    
    init(size: CGSize, isDarkMode: Bool, screenWidth: CGFloat, heightOffset: CGFloat) {
        runColor = isDarkMode ? "White" : "Black"
        movingSpeed = CGFloat(startSpeed)
        ground = RunGround(heightOffset: heightOffset)
        kangaroo = Kangaroo(heighOffset: heightOffset)
        obstacles = Obstacles(heightOffset: heightOffset)
        button = GameButton(pos: CGPoint(x: size.width / 2, y: size.height / 2), color: runColor)
        scoreLabel = ScoreLabel(pos: CGPoint(x: screenWidth * 0.89, y: 220 + heightOffset), isDarkMode: isDarkMode)
        ugIcons = UndergroundIcons(heightOffset: heightOffset)
        super.init(size: size)
        button.delegate = self
        self.backgroundColor = isDarkMode ? .black : .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to: SKView) {
        addChild(ground)
        addChild(kangaroo)
        addChild(obstacles)
        addChild(button)
        addChild(scoreLabel)
        addChild(ugIcons)
        addSwipeGestureRecognizers()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOn{
            kangaroo.updateVerticalPosition()
            ground.updateHorizontalPosition(speed: movingSpeed)
            obstacles.updateHorizontalPosition(speed: movingSpeed)
            scoreLabel.updateScoreLabel()
            increaseSpeed(score: scoreLabel.score)
            if kangaroo.checkCollisionWithObstacles(sockets: obstacles.socketsArr) {
                obstacles.removeAnimations()
                isGameOn = false
                button.showButton()
                Task {
                    do {
                        try await AuthManager.shared.savePlayerScore(field: "runScore", score: Double(scoreLabel.score))
                    }
                    catch {
                        runVm?.alertText = error.localizedDescription
                        runVm?.isAlertOn.toggle()
                    }
                }
            }
        }
    }
    
    // Handling swipe gestures
    func addSwipeGestureRecognizers() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down]
        for gestureDirection in gestureDirections {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureRecognizer.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureRecognizer)
        }
    }
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction{
        case .up:
            kangaroo.jump()
        case .down:
            kangaroo.crouch()
        default:
            print("No such a gesture")
        }
    }
    
    func startGame() {
        scoreLabel.resetScore()
        obstacles.removeSockets()
        obstacles.generateSocket(offsetX: 0)
        kangaroo.restartKangaroo()
        button.hideButton()
        isGameOn = true
    }
    
    private func increaseSpeed(score: Int) {
        if score % 30 == 0 {
            movingSpeed = CGFloat(score / 30 + startSpeed)
        }
    }
}
