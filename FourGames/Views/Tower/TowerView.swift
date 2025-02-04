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
                LogoView(logoName: "towerBuild", size: towerVm.adjustLogoWidth())
                Spacer()
            }
        }
        .alert(isPresented: $towerVm.isAlertOn) {
            Alert(
                title: Text(towerVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    TowerView()
}
