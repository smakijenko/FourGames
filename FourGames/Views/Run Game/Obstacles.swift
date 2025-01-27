//
//  Obstacles.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 26/11/2024.
//

import Foundation
import SpriteKit

struct Socket {
    var sprites: [SKSpriteNode]
    var isParent: Bool = false
}

class Obstacles: SKNode {
    private let defaultPos = CGPoint(x: -50, y: -50)
    private let cactusSize = CGSize(width: 30, height: 60)
    private let tumbleWeedSize = CGSize(width: 30, height: 25)
    private let eagleSize = CGSize(width: 40, height: 25)
    private let obstacleWidth: CGFloat = 30
    private let maxScktLength = 3
    private let minObsDist: CGFloat = 300
    private let animationSpeed = 0.35
    private let startX: CGFloat
    private let offset: CGFloat
    private var eagleTextures: [SKTexture] = []
    private var freeObstaclesArr: [SKSpriteNode] = []
    var socketsArr: [Socket] = []
    
    init(heightOffset: CGFloat) {
        startX = screenSize.width + obstacleWidth / 2
        offset = heightOffset + 5
        super.init()
        loadEagleTextures()
        createObstacles(socketsNum: countSockets(screenWidth: screenSize.width))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadEagleTextures() {
        for i in 1 ... 2 {
            eagleTextures.append(SKTexture(imageNamed: "eagleIdle\(runColor)\(i)"))
        }
    }
    
    func removeAnimations() {
        for socket in socketsArr{
            for obstacle in socket.sprites{
                obstacle.removeAllActions()
            }
        }
    }
    
    private func countSockets(screenWidth: CGFloat) -> Int {
        return Int(ceil(screenWidth / minObsDist) + 2)
    }
    
    private func randomDistance() -> CGFloat {
        return CGFloat.random(in: 0 ... 150)
    }
    
    private func pickRandomObstacleName() -> String {
        return (Bool.random() ? "cactus" : "tumbleweed") + runColor
    }
    
    private func createObstacles(socketsNum: Int) {
        for _ in 0 ..< socketsNum * maxScktLength{
            let obstacle = SKSpriteNode(imageNamed: "emptyObs")
            obstacle.position = defaultPos
            obstacle.zPosition = 3
            freeObstaclesArr.append(obstacle)
            addChild(obstacle)
        }
    }
    
    func generateSocket(offsetX: CGFloat) {
        var socket: [SKSpriteNode] = []
        let randNum = Int.random(in: 1 ... 10)
        var obstacleCount: Int = 1
        if 1 ... 6 ~= randNum && freeObstaclesArr.count > 0{obstacleCount = 1}
        else if 7 ... 8 ~= randNum && freeObstaclesArr.count > 1{obstacleCount = 2}
        else if 9 ... 10 ~= randNum && freeObstaclesArr.count > 2{obstacleCount = 3}
        for _ in 0 ..< obstacleCount {
            socket.append(freeObstaclesArr.removeLast())
        }
        if !socket.isEmpty {
            if socket.count == 1 {
                let isEagle = Int.random(in: 1 ... 10)
                if 8 ... 10 ~= isEagle {
                    socket[0].removeAllActions()
                    socket[0].size = eagleSize
                    socket[0].run(SKAction.repeatForever(SKAction.animate(with: eagleTextures, timePerFrame: animationSpeed)))
                    socket[0].position = CGPoint(
                        x: startX + offsetX,
                        y: 60 + offset
                    )
                    socketsArr.append(Socket(sprites: socket))
                    return
                }
            }
            for (i, obstacle) in socket.enumerated() {
                obstacle.removeAllActions()
                let name = pickRandomObstacleName()
                obstacle.texture = SKTexture(imageNamed: name)
                switch name {
                case "cactus\(runColor)":
                    obstacle.size = cactusSize
                case "tumbleweed\(runColor)":
                    obstacle.size = tumbleWeedSize
                default:
                    break
                }
                obstacle.position = CGPoint(
                    x: startX + CGFloat(i) * obstacleWidth + offsetX,
                    y: obstacle.size.height / 2 + offset
                )
            }
            socketsArr.append(Socket(sprites: socket))
        }
    }
    
    func removeSockets() {
        for socket in socketsArr{
            for obstacle in socket.sprites{
                obstacle.position = defaultPos
                freeObstaclesArr.append(obstacle)
            }
        }
        socketsArr = []
    }
    
    func updateHorizontalPosition(speed: CGFloat){
        for socket in socketsArr{
            for obstacle in socket.sprites{
                obstacle.position.x -= speed
            }
        }
        
        guard let firstNoParentScktIndex = socketsArr.firstIndex(where: { !$0.isParent }) else { return }
        if let lastScktX = socketsArr[firstNoParentScktIndex].sprites.last?.position.x, lastScktX <= startX - minObsDist {
            socketsArr[firstNoParentScktIndex].isParent = true
            generateSocket(offsetX: randomDistance())
        }
        
        guard let firstParentScktIndex = socketsArr.firstIndex(where: { $0.isParent }) else { return }
        if let lastScktX = socketsArr[firstParentScktIndex].sprites.last?.position.x, lastScktX <= -obstacleWidth / 2 {
            for obstacle in socketsArr[firstParentScktIndex].sprites {
                obstacle.position = defaultPos
                obstacle.removeAllActions()
                freeObstaclesArr.append(obstacle)
            }
            socketsArr.remove(at: firstParentScktIndex)
        }
    }
}
