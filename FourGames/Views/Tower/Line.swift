//
//  Line.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 01/01/2025.
//

import Foundation
import SpriteKit
import SwiftUI

class Line: SKNode {
    private let startPoint: CGPoint
    private let yOffset: CGFloat = 50
    let line = SKShapeNode()
    
    init(startPoint: CGPoint) {
        self.startPoint = startPoint
        super.init()
        line.strokeColor = .white
        chooseColor()
        line.lineWidth = 5
        addChild(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLine(endPoint: CGPoint) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: startPoint.x, y: startPoint.y - yOffset))
        path.addLine(to: endPoint)
        line.path = path
    }
    
    private func chooseColor() {
        if towerColor == "White" { line.strokeColor = .white }
        else { line.strokeColor = .black }
    }
}
