//
//  WordsView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 16/11/2024.
//

import SwiftUI

struct WordsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var wordsVm = WordsViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                timer
                letterGrid
                wordsToFind
                if !wordsVm.isGameOn {
                    startButton(isDarkMode: colorScheme == .dark)
                }
                Spacer()
            }
            .padding(.top, wordsVm.adjustLogoSize().height)
            if wordsVm.isGameOver {
                gameOverView(isDarkMode: colorScheme == .dark)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            }
            VStack {
                LogoView(logoName: "wordSearch", size: wordsVm.adjustLogoSize().width)
                Spacer()
            }
        }
        .alert(isPresented: $wordsVm.isAlertOn) {
            Alert(
                title: Text(wordsVm.alertText),
                message: Text("Try again once again."),
                dismissButton: .default(Text("Ok")))
        }
    }
}

#Preview {
    WordsView()
}

extension WordsView {
    private var timer: some View {
        Text(String(format: "%.1f", wordsVm.elapsedTime))
            .font(.title)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
    }
    
    private var letterGrid: some View {
        VStack(spacing: 2) {
            ForEach(0 ..< wordsVm.squareSideLenght, id: \.self) { i in
                HStack(spacing: 2) {
                    ForEach(0 ..< wordsVm.squareSideLenght, id: \.self) { j in
                        tile(letter: wordsVm.tileLetter[i][j], row: i, col: j)
                    }
                }
            }
        }
        .clipShape(.rect(cornerRadius: 5))
        .gesture(searchingGesture)
        .disabled(!wordsVm.isGameOn)
    }
    
    private func tile(letter: Character, row: Int, col: Int) -> some View {
        return Rectangle()
            .foregroundStyle(wordsVm.tileColor[row][col])
            .overlay(content: {
                Text("\(letter)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .minimumScaleFactor(0.1)
            })
            .frame(width: wordsVm.tileWidth, height: wordsVm.tileWidth)
    }
    
    private var searchingGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                if !wordsVm.isTouchStart {
                    wordsVm.defineStartTile(startPoint: value.location)
                    wordsVm.isTouchStart = true
                }
                wordsVm.updateTilesState(at: value.location)
            })
            .onEnded({ value in
                wordsVm.manageTouchEnd()
            })
    }
    
    private var wordsToFind: some View {
        HStack(alignment: .top) {
            wordColumn(align: .leading, degree: 2, evenCondition: true)
            Spacer()
            wordColumn(align: .trailing, degree: -2, evenCondition: false)
        }
        .padding(.horizontal, wordsVm.adjustWordsToFindPadding())
    }
    
    private func wordColumn(align: HorizontalAlignment, degree: Double, evenCondition: Bool) -> some View {
        VStack(alignment: align) {
            ForEach(Array(wordsVm.wordsToFind.enumerated()), id: \.element.id) { index, word in
                if (index % 2 == 0) == evenCondition {
                    VStack(alignment: align) {
                        Text(word.english)
                            .font(.title2)
                            .fontWeight(.medium)
                        Text(word.polish)
                            .font(.caption)
                    }
                    .foregroundStyle(.primary)
                    .rotationEffect(Angle(degrees: degree))
                    .minimumScaleFactor(0.1)
                }
            }
        }
    }
    
    private func startButton(isDarkMode: Bool) -> some View {
        Button {
            wordsVm.restartTheGame()
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
                    Text("Score: " + String(format: "%.1f", wordsVm.elapsedTime))
                }
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                startButton(isDarkMode: isDarkMode)
            }
            .onAppear {
                Task {
                    do {
                        let roundedValue = (wordsVm.elapsedTime * 10).rounded() / 10
                        try await AuthManager.shared.savePlayerScore(field: "wordsScore", score: roundedValue)
                    }
                    catch {
                        wordsVm.alertText = error.localizedDescription
                        wordsVm.isAlertOn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
