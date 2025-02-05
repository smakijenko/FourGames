//
//  BlocksManager.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 30/12/2024.
//

import Foundation
import SpriteKit

class BlocksManager: SKShapeNode{
    private let startHeight: CGFloat = 600
    private let cameraOffset: CGFloat = 50
    private var line: Line
    private var isBlockDropped: Bool = false
    private var blocks: [Block] = []
    private var groundedBlocks: [Block] = []
    var score: Int = 0
    var lifes: Int = 3
    
    override init() {
        line = Line(startPoint: CGPoint(x: screenSize.width / 2, y: screenSize.height + 5))
        super.init()
        addChild(line)
        createBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkForDropTouch() {
        guard !blocks.isEmpty && !isBlockDropped else { return }
        isBlockDropped = true
    }
    
    func updateBlockPosition(groundHeight: CGFloat, ground: TowerGround) {
        guard let lastBlock = blocks.last else { return }
        if !isBlockDropped {
            lastBlock.swingTheBlock()
            line.updateLine(endPoint: CGPoint(x: lastBlock.block.position.x, y: lastBlock.block.position.y + lastBlock.blockHeight / 2.1))
        }
        else {
            lastBlock.updateHorizontalPosition(groundHeight: groundHeight, numOfBlocks: groundedBlocks.count)
            
            if let topGroundedBlock = groundedBlocks.last {
                if lastBlock.checkIfIsAimed(topGroundedBlock: topGroundedBlock) {
                    lastBlock.isAimed = true
                    lastBlock.inAir = false
                    lastBlock.block.position.y = topGroundedBlock.block.position.y + topGroundedBlock.blockHeight
                }
            }
            
            if lastBlock.isAimed {
                groundedBlocks.append(lastBlock)
                score += 1
                if groundedBlocks.count > 3 {
                    ground.moveDown(offset: cameraOffset)
                    for block in groundedBlocks {
                        block.moveDown(offset: cameraOffset)
                    }
                }
            }
            
            if !lastBlock.inAir && !lastBlock.isAimed {
                lifes -= 1
            }
            
            if !lastBlock.inAir {
                blocks.removeAll()
                isBlockDropped = false
                createBlock()
            }
        }
    }
    
    func restartBlocks() {
        lifes = 3
        removeChildren(in: groundedBlocks)
        blocks.removeAll()
        groundedBlocks.removeAll()
        createBlock()
    }
    
    private func createBlock() {
        let block = Block()
        blocks.append(block)
        addChild(block)
    }
}
