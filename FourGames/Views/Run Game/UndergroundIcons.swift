//
//  UndergroundIcons.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 05/12/2024.
//

import Foundation
import SpriteKit

class UndergroundIcons: SKNode {
    private let boneSize = CGSize(width: 70, height: 23)
    private let fernSize = CGSize(width: 74, height: 81)
    private let groundHeight: CGFloat
    
    init(heightOffset: CGFloat) {
        groundHeight = heightOffset
        super.init()
        generateUndergroundIcons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateUndergroundIcons() {
        var possiblePositions: [CGPoint] = []
        let yRange = 40 ..< (groundHeight - 40)
        let xRange = 40 ..< (screenSize.width - 40)
        let step: CGFloat = 60
        for x in stride(from: xRange.lowerBound, to: xRange.upperBound, by: step) {
            for y in stride(from: yRange.lowerBound, to: yRange.upperBound, by: step) {
                possiblePositions.append(CGPoint(x: x, y: y))
            }
        }
        possiblePositions.shuffle()
        let iconsNum = Int.random(in: 11 ... 14)
        for _ in 0 ..< iconsNum {
            let name = (Bool.random() ? "bone" : "fern") + runColor
            let rotation = Double.random(in: 0 ... 365)
            let scale = CGFloat.random(in: 0.40 ... 0.60)
            let ugIcon = SKSpriteNode()
            ugIcon.texture = SKTexture(imageNamed: name)
            ugIcon.zRotation = convertToRadians(degrees: rotation)
            ugIcon.zPosition = 0
            if name == "bone\(runColor)" {
                ugIcon.size = boneSize
            }
            else if name == "fern\(runColor)" {
                ugIcon.size = fernSize
            }
            ugIcon.setScale(scale)
            ugIcon.position = possiblePositions.removeFirst()
            addChild(ugIcon)
        }
    }
    
    private func convertToRadians(degrees: Double) -> Double {
        return .pi * degrees / 180
    }
            
    private func checkDistance(pos: CGPoint, ugIconsArr: [SKSpriteNode]) -> Bool {
        for icon in ugIconsArr{
            if distanceBetweenPoints(CGPoint(x: icon.position.x, y: icon.position.y), pos) < 60 {return false}
        }
        return true
    }
    
    private func distanceBetweenPoints(_ p1: CGPoint, _ p2: CGPoint) -> Double {
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            return sqrt(dx * dx + dy * dy)
    }
}
