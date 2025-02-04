//
//  TowerViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 28/12/2024.
//

import Foundation
import SwiftUI
import SpriteKit

class TowerViewModel: ObservableObject {
    @Published var isAlertOn: Bool = false
    @Published var alertText: String = ""
    let gameSceneSize: CGSize

    init() {
        gameSceneSize = CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    func createScene(isDarkMode: Bool) -> SKScene {
        let scene = TowerGameScene(size: gameSceneSize, isDarkMode: isDarkMode)
        scene.scaleMode = .resizeFill
        scene.towerVm = self
        return scene
    }
    
    func adjustLogoWidth() -> CGFloat{
        let width = screenSize.width * 0.89
        if width > 550 {return 550}
        return width
    }
}
