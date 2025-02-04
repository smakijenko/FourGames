//
//  TowerGameScene.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 28/12/2024.
//

import Foundation
import SpriteKit

var towerColor: String = ""

class TowerGameScene: SKScene, GameButtonDelegate{
    weak var towerVm: TowerViewModel?
    private let ground: TowerGround
    private let blocks: BlocksManager
    private let button: GameButton
    private let scoreLabel: ScoreLabel
    private let hearts: Hearts
    private var isGameOn = false
    
    init(size: CGSize, isDarkMode: Bool) {
        towerColor = isDarkMode ? "White" : "Black"
        ground = TowerGround()
        blocks = BlocksManager()
        button = GameButton(pos: CGPoint(x: size.width / 2, y: size.height / 2), color: towerColor)
        scoreLabel = ScoreLabel(pos: CGPoint(x: size.width / 1.21, y: 17), isDarkMode: isDarkMode)
        hearts = Hearts(position: CGPoint(x: size.width / 10, y: 28))
        super.init(size: size)
        button.delegate = self
        self.backgroundColor = isDarkMode ? .black : .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        addChild(ground)
        addChild(blocks)
        addChild(button)
        addChild(scoreLabel)
        addChild(hearts)
    }
    
    override func update(_ currentTime: TimeInterval) {
        blocks.updateBlockPosition(groundHeight: ground.topPosition, ground: ground)
        scoreLabel.showLable(score: blocks.score)
        hearts.updateHearts(count: blocks.lifes)
        if blocks.lifes <= 0 {
            blocks.restartBlocks()
            ground.restartGround()
            button.showButton()
            isGameOn = false
            Task {
                do {
                    try await AuthManager.shared.savePlayerScore(field: "runScore", score: Double(blocks.score))
                }
                catch {
                    towerVm?.alertText = error.localizedDescription
                    towerVm?.isAlertOn.toggle()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !button.isVisible {
            blocks.checkForDropTouch()
        }
    }
    
    func startGame() {
        isGameOn = true
        blocks.checkForDropTouch()
        button.hideButton()
    }
}
