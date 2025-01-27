//
//  GameButton.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 02/12/2024.
//

import Foundation
import SpriteKit

protocol GameButtonDelegate: AnyObject {
    func startGame()
}

class GameButton: SKNode{
    private let btnSize = CGSize(width: 110, height: 60)
    private let btn: SKSpriteNode
    weak var delegate: GameButtonDelegate?
    var isVisible: Bool = true
    
    init(pos: CGPoint, color: String) {
        btn = SKSpriteNode(imageNamed: "playButton\(color)")
        super.init()
        isUserInteractionEnabled = true
        btn.position = pos
        btn.zPosition = 4
        btn.size = btnSize
        addChild(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideButton(){
        btn.alpha = 0
        isVisible = false
        isUserInteractionEnabled = false
    }
    
    func showButton(){
        btn.alpha = 1
        isVisible = true
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            let location = touch.location(in: self)
            if btn.contains(location){
                btn.setScale(0.85)
                btn.alpha = 0.85
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        btn.setScale(1)
        btn.alpha = 1
        delegate?.startGame()
    }
}
