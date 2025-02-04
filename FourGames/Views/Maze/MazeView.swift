//
//  MazeView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI

struct MazeView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var mazeVm = MazeViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                timer
                ZStack {
                    tileGrid
                        .overlay {
                            if mazeVm.isGameOn {
                                icon(iconName: "mazeStart", tilePos: mazeVm.startTile)
                                icon(iconName: "mazeFinish", tilePos: mazeVm.endTile)
                            }
                        }
                }
                if !mazeVm.isGameOn {
                    startButton(isDarkMode: colorScheme == .dark)
                }
                Spacer()
            }
            .padding(.top, mazeVm.adjustLogoSize().height)
            if mazeVm.isGameOver {
                gameOverView(isDarkMode: colorScheme == .dark)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            }
            VStack {
                LogoView(logoName: "maze", size: mazeVm.adjustLogoSize().width)
                Spacer()
            }
        }
        .alert(isPresented: $mazeVm.isAlertOn) {
            Alert(
                title: Text(mazeVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    MazeView()
}

extension MazeView {
    private var timer: some View {
        Text(String(format: "%.1f", mazeVm.elapsedTime))
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
    }
    
    private var tileGrid: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< mazeVm.mazeSize, id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0 ..< mazeVm.mazeSize, id: \.self) { j in
                        tile(row: i, col: j)
                    }
                }
            }
        }
        .clipShape(.rect(cornerRadius: 5))
        .shadow(color: .white, radius: 2)
        .gesture(solvingGesture)
        .disabled(!mazeVm.isGameOn)
    }
    
    private func tile(row: Int, col: Int) -> some View {
        var tileColor: Color = .white
        if mazeVm.mazeArr[row][col] == "1" {tileColor = .black}
        else if mazeVm.mazeArr[row][col] == "2" {tileColor = .green}
        else if mazeVm.mazeArr[row][col] == "3" {tileColor = .red}
        else if mazeVm.mazeArr[row][col] == "4" {tileColor = .gray}
        return Rectangle()
            .foregroundStyle(tileColor)
            .frame(width: mazeVm.tileWidth, height: mazeVm.tileWidth)
    }
    
    private var solvingGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                mazeVm.manageSolving(at: value.location)
                mazeVm.checkIfMazeSolved()
            })
            .onEnded({ value in
                mazeVm.manageTouchEnd()
            })
    }
    
    private func icon(iconName: String, tilePos: (Int, Int)) -> some View {
        let offsetS = mazeVm.adjustIconOffset(tilePos: tilePos)
        return Image(colorScheme == .dark ? "\(iconName)Black" : "\(iconName)White")
            .resizable()
            .frame(width: mazeVm.tileWidth, height: mazeVm.tileWidth)
            .offset(x:offsetS.1, y: offsetS.0)
    }
    
    private func startButton(isDarkMode: Bool) -> some View {
        Button {
            mazeVm.restartTheGame()
        } label: {
            Image(isDarkMode ? "playButtonWhite" : "playButtonBlack")
        }
    }
    
    private func gameOverView(isDarkMode: Bool) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
            VStack {
                VStack(spacing: 10) {
                    Text("Best score: 42.0") // TODO
                    Text("Score: " + String(format: "%.1f", mazeVm.elapsedTime))
                }
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                startButton(isDarkMode: isDarkMode)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                do {
                    try await AuthManager.shared.savePlayerScore(field: "mazeScore", score: mazeVm.elapsedTime)
                }
                catch {
                    mazeVm.alertText = error.localizedDescription
                    mazeVm.isAlertOn.toggle()
                }
            }
        }
    }
}
