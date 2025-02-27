//
//  RunView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI
import SpriteKit

struct RunView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var runVm = RunViewModel()
    
    var body: some View {
        ZStack{
            SpriteView(scene: runVm.createScene(isDarkMode: colorScheme == .dark))
                .ignoresSafeArea()
            VStack{
                LogoView(logoName: "kangRun", size: runVm.adjustLogoWidth())
                Spacer()
            }
        }
        .alert(isPresented: $runVm.isAlertOn) {
            Alert(
                title: Text(runVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    RunView()
}
