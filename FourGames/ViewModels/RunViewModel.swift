//
//  RunViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 19/11/2024.
//

import Foundation
import SwiftUI
import SpriteKit

class RunViewModel: ObservableObject{
    private let gameHeight: CGFloat = 250
    let gameSceneSize: CGSize
    
    init(){
        gameSceneSize = CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    func createScene(isDarkMode: Bool) -> SKScene {
        let scene = RunGameScene(size: gameSceneSize, isDarkMode: isDarkMode, screenWidth: gameSceneSize.width, heightOffset: adjustGameOffset())
        scene.scaleMode = .resizeFill
        return scene
    }
    
    func adjustGameOffset() -> CGFloat {
        return screenSize.height - (screenSize.height / 2 + gameHeight / 2)
    }
    
    func adjustLogoWidth() -> CGFloat{
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
}
