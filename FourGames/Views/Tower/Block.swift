//
//  Block.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 29/12/2024.
//

import Foundation
import SwiftUI
import SpriteKit

class Block: SKShapeNode {
    private let g: CGFloat = 0.035
    private let sidePicker = Bool.random()
    private let sidePickMultiplier: CGFloat
    private let defaultBlockWidth: CGFloat = 50
    private var acce: CGFloat = 0
    private var velo: CGFloat = 0
    private var len: Double = 0
    private var angle: Double = Double.pi / 6
    private var angleV: Double = 0
    private var angleA: Double = 0.01
    private var swingG: Double = 0.3
    let block: SKShapeNode
    let blockHeight: CGFloat = 50
    var blockWidth: CGFloat = 50
    var inAir: Bool = true
    var isAimed: Bool = false
    
    override init() {
        block = SKShapeNode(rectOf: CGSize(width: defaultBlockWidth, height: blockHeight), cornerRadius: 5)
        sidePickMultiplier = sidePicker ? -1 : 1
        len = UIScreen.main.bounds.width * 0.5
        super.init()
        block.strokeColor = .clear
        block.fillColor = .white
        chooseColor()
        block.position = CGPoint(x: -blockHeight, y: 800)
        chooseWidth()
        addChild(block)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func chooseWidth() {
        let widthRange: ClosedRange<CGFloat> = 15 ... 75
        let width = CGFloat.random(in: widthRange)
        blockWidth = width
        block.xScale = width / defaultBlockWidth
    }
    
    func updateHorizontalPosition(groundHeight: CGFloat, numOfBlocks: Int) {
        guard inAir else { return }
        if block.position.y <= groundHeight + blockHeight && numOfBlocks < 1 {
            block.position.y = groundHeight + blockHeight / 2
            isAimed = true
            inAir = false
        }
        else {
            acce += g
            velo += acce
            block.position.y -= velo
        }
        if block.position.y <= 0 {
            inAir = false
            block.removeFromParent()
        }
    }
    
    func checkIfIsAimed(topGroundedBlock: Block) -> Bool {
        let xRange = topGroundedBlock.block.position.x - topGroundedBlock.blockWidth / 2 ... topGroundedBlock.block.position.x + topGroundedBlock.blockWidth / 2
        if xRange.contains(block.position.x) && block.position.y - blockHeight / 2 <= topGroundedBlock.block.position.y + topGroundedBlock.blockHeight {
            return true
        }
        return false
    }
    
    func swingTheBlock() {
        let force = swingG * cos(angle) / len
        angleA = force
        angleV += angleA
        angle += angleV
        block.position.x = -1 * len * cos(angle) + screenSize.width / 2
        block.position.y = -len * sin(angle) + screenSize.height * 0.9
    }
    
    func moveDown(offset: CGFloat) {
        block.position.y -= offset
    }
    
    private func chooseColor() {
        if towerColor == "White" { block.fillColor = .white }
        else { block.fillColor = .black }
    }
}
