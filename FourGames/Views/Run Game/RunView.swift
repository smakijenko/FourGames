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
                logo
                Spacer()
            }
        }
    }
}

#Preview {
    RunView()
}

extension RunView{
    private var logo: some View{
        Image(colorScheme == .dark ? "kangRunLogoWhite" : "kangRunLogoBlack")
            .resizable()
            .scaledToFit()
            .frame(width: runVm.adjustLogoWidth())
    }
}
