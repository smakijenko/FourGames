//
//  ScoreLabel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 02/12/2024.
//

import Foundation
import SpriteKit

class ScoreLabel: SKNode {
    private let label: SKLabelNode
    private let typeLabel: SKLabelNode
    private let background: SKShapeNode
    private var ticks: Int = 0
    var score: Int = 0
    
    init(pos: CGPoint, isDarkMode: Bool, type: String) {
        label = SKLabelNode(text: "000\(score)")
        typeLabel = SKLabelNode(text: type)
        background = SKShapeNode(rectOf: CGSize(width: 90, height: 27), cornerRadius: 7.5)
        super.init()
        background.strokeColor = .clear
        background.fillColor = isDarkMode ? .black : .white
        background.position.x = pos.x
        background.position.y = pos.y + 10
        label.position = pos
        label.zPosition = 4
        label.fontColor = isDarkMode ? .white : .black
        label.fontSize = 25
        label.fontName = "Joystix"
        typeLabel.position = CGPoint(x: pos.x, y: pos.y + 25)
        typeLabel.zPosition = 4
        typeLabel.fontColor = isDarkMode ? .white : .black
        typeLabel.fontSize = 20
        typeLabel.fontName = "Joystix"
        addChild(background)
        addChild(label)
        addChild(typeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScoreLabel() {
        ticks += 1
        score = Int(floor(Double(ticks) / 25))
        var labelText = ""
        if 0 ... 9 ~= score {labelText = "000\(score)"}
        else if 10 ... 99 ~= score {labelText = "00\(score)"}
        else if 100 ... 999 ~= score {labelText = "0\(score)"}
        else {labelText = "\(score)"}
        label.text = labelText
    }
    
    func showLable(score: Int) {
        var labelText = ""
        if 0 ... 9 ~= score {labelText = "000\(score)"}
        else if 10 ... 99 ~= score {labelText = "00\(score)"}
        else if 100 ... 999 ~= score {labelText = "0\(score)"}
        else {labelText = "\(score)"}
        label.text = labelText
    }
    
    func resetScore() {
        ticks = 0
        score = 0
        label.text = "000\(score)"
    }
}
