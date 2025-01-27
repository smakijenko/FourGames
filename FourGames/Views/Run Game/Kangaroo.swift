//
//  Kangaroo.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 20/11/2024.
//

import Foundation
import SpriteKit

class Kangaroo: SKNode {
    enum states {
        case onGround
        case inAir
        case crouching
    }
    
    private let kangRunSize = CGSize(width: 60, height: 50)
    private let kangCrouchSize = CGSize(width: 72, height: 37)
    private let g: CGFloat = 0.03
    private let crouchTime: CGFloat = 0.5
    private let kangaroo: SKSpriteNode
    private let offset: CGFloat
    
    private var runTextures: [SKTexture] = []
    private var crouchTextures: [SKTexture] = []
    private var acce: CGFloat = 0
    private var velo: CGFloat = 0
    private var animationSpeed: CGFloat = 0.15
    private var kangarooState: states = .onGround
    private var isAlive: Bool = true
        
    init(heighOffset: CGFloat) {
        kangaroo = SKSpriteNode(imageNamed: "kangRun\(runColor)1")
        offset = heighOffset + 5
        super.init()
        kangaroo.size = kangRunSize
        kangaroo.position.x = 70
        kangaroo.position.y = kangaroo.size.height / 2 + offset
        kangaroo.zPosition = 2
        loadTextures()
        addChild(kangaroo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadTextures() {
        for i in 1 ... 3 {
            runTextures.append(SKTexture(imageNamed: "kangRun\(runColor)\(i)"))
            crouchTextures.append(SKTexture(imageNamed: "kangCrouch\(runColor)\(i)"))
        }
    }
    
    private func runAnimation() {
        if !kangaroo.hasActions() {
            kangaroo.run(SKAction.repeatForever(SKAction.animate(with: runTextures, timePerFrame: animationSpeed)))
        }
    }
    
    private func crouchAnimation() {
        if !kangaroo.hasActions() {
            kangaroo.run(SKAction.repeatForever(SKAction.animate(with: crouchTextures, timePerFrame: animationSpeed)))
        }
    }
    
    private func removeAnimations() {
        kangaroo.removeAllActions()
        kangaroo.size = kangRunSize
        kangaroo.texture = runTextures[1]
    }
    
    func jump() {
        if kangarooState != .inAir {
            kangarooState = .inAir
            removeAnimations()
            acce = 0
            velo = -g / 0.0035
            kangaroo.position.y -= velo
        }
    }
    
    func crouch() {
        if kangarooState == .inAir {
            acce = 3
            return
        }
        kangarooState = .crouching
        removeAnimations()
        kangaroo.size = kangCrouchSize
        crouchAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + crouchTime) {
            if self.kangarooState == .crouching && self.isAlive{
                self.kangarooState = .onGround
                self.removeAnimations()
                self.kangaroo.size = self.kangRunSize
                self.runAnimation()
            }
        }
    }

    func updateVerticalPosition() {
        acce += g
        velo += acce
        kangaroo.position.y -= velo
        if kangaroo.position.y <= kangaroo.size.height / 2 + offset {
            kangaroo.position.y = kangaroo.size.height / 2 + offset
            if kangarooState == .inAir{
                kangarooState = .onGround
                runAnimation()
            }
        }
    }
    
    func checkCollisionWithObstacles(sockets: [Socket]) -> Bool{
        for sckt in sockets {
            for obs in sckt.sprites {
                if kangaroo.frame.intersects(obs.frame) {
                    isAlive = false
                    if kangarooState != .crouching {
                        removeAnimations()
                    }
                    else {
                        diedCrouching()
                    }
                    return true
                }
            }
        }
        return false
    }
    
    private func diedCrouching() {
        kangaroo.removeAllActions()
        kangaroo.size = kangCrouchSize
        kangaroo.texture = crouchTextures[0]
        kangaroo.position.y = kangaroo.size.height / 2 + offset
    }
    
    func restartKangaroo() {
        kangaroo.size = kangRunSize
        kangarooState = .onGround
        acce = 0
        velo = 0
        isAlive = true
        kangaroo.position.y = kangaroo.size.height / 2 + offset
        runAnimation()
    }
}
