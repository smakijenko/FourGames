//
//  Ground.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 19/11/2024.
//

import Foundation
import SpriteKit

class RunGround: SKNode {
    private let startPos: CGPoint
    private let tileWidth: CGFloat = 50
    private var tilesArr: [SKSpriteNode] = []
    
    init(heightOffset: CGFloat) {
        startPos = CGPoint(x: 25, y: 5 + heightOffset)
        super.init()
        createGround(tilesNum: countTiles(screenWidth: screenSize.width))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func countTiles(screenWidth: CGFloat) -> Int {
        return Int(ceil(screenWidth / tileWidth) + 2)
    }
    
    private func pickRandomTileName() -> String {
        let randNum = Int.random(in: 1...11)
        if 1 ... 7 ~= randNum {return "noHillGround\(runColor)"}
        else if 8 ... 9 ~= randNum {return "doubleHillGround\(runColor)"}
        else {return "singleHillGround\(runColor)"}
    }
    
    private func createGround(tilesNum: Int) {
        for i in 0..<tilesNum {
            let tile = SKSpriteNode(imageNamed: pickRandomTileName())
            let offset = CGFloat(CGFloat(i) * tileWidth)
            tile.position = CGPoint(x: startPos.x + offset, y: startPos.y)
            tile.zPosition = 1
            tilesArr.append(tile)
            addChild(tile)
        }
    }
    
    func updateHorizontalPosition(speed: CGFloat) {
        var indOut: [Int] = []
        for i in 0 ..< tilesArr.count {
            tilesArr[i].position.x -= speed
            if tilesArr[i].position.x <= -tileWidth / 2 {
                indOut.append(i)
            }
        }
        for ind in indOut {
            if ind == 0 {
                if let lastTile = tilesArr.last {
                    tilesArr[0].position.x = lastTile.position.x + tileWidth
                }
            }
            else {
                tilesArr[ind].position.x = tilesArr[ind - 1].position.x + tileWidth
            }
            tilesArr[ind].texture = SKTexture(imageNamed: pickRandomTileName())
        }
    }
}
