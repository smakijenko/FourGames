//
//  TowerView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI
import SpriteKit


struct TowerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var towerVm = TowerViewModel()
    var body: some View {
        ZStack{
            SpriteView(scene: towerVm.createScene(isDarkMode: colorScheme == .dark))
                .ignoresSafeArea()
            VStack{
                logo
                Spacer()
            }
        }
    }
}

#Preview {
    TowerView()
}

extension TowerView{
    private var logo: some View{
        Image(colorScheme == .dark ? "towerBuildLogoWhite" : "towerBuildLogoBlack")
            .resizable()
            .scaledToFit()
            .frame(width: towerVm.adjustLogoWidth())
    }
}
