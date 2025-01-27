//
//  TowerGround.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 29/12/2024.
//

import Foundation
import SpriteKit

class TowerGround: SKNode {
    private let ground: SKSpriteNode
    private let groundHeight: CGFloat = 25
    private let yPos: CGFloat = 75
    var topPosition: CGFloat = 0
    
    override init() {
        ground = SKSpriteNode(imageNamed: "ground\(towerColor)")
        super.init()
        ground.position = CGPoint(x: screenSize.width / 2, y: yPos)
        ground.size = CGSize(width: screenSize.width, height: groundHeight)
        topPosition = ground.position.y + groundHeight / 2
        addChild(ground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveDown(offset: CGFloat) {
        ground.position.y -= offset
    }
    
    func restartGround() {
        ground.position.y = yPos
    }
}
