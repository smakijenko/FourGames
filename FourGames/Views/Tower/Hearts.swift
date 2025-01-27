//
//  Hearts.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 03/01/2025.
//

import Foundation
import SpriteKit

class Hearts: SKNode {
    private let heartSize = CGSize(width: 24, height: 20)
    private let xOffset: CGFloat
    private let background: SKShapeNode
    private var hearts: [SKSpriteNode] = [SKSpriteNode(imageNamed: "heartIcon\(towerColor)"), SKSpriteNode(imageNamed: "heartIcon\(towerColor)"), SKSpriteNode(imageNamed: "heartIcon\(towerColor)")]
    
    init(position: CGPoint) {
        xOffset = heartSize.width + 5
        background = SKShapeNode(rectOf: CGSize(width: heartSize.width * 3 + 21, height: heartSize.height + 6), cornerRadius: 7.5)
        super.init()
        background.position.x = position.x + xOffset
        background.position.y = position.y
        background.strokeColor = .clear
        chooseColor()
        addChild(background)
        adjustHeartsSettings(pos: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHearts(count: Int) {
        guard count >= 0 else { return }
        for heart in hearts {
            heart.alpha = 0
        }
        for i in 0..<count {
            hearts[i].alpha = 1
        }
    }
    
    private func adjustHeartsSettings(pos: CGPoint) {
        for (index, heart) in hearts.enumerated() {
            heart.position.x = pos.x + (xOffset * CGFloat(index))
            heart.position.y = pos.y
            heart.size = heartSize
            heart.alpha = 0
            addChild(heart)
        }
    }
    
    private func chooseColor() {
        if towerColor == "Black" { background.fillColor = .white }
        else { background.fillColor = .black }
    }
}
