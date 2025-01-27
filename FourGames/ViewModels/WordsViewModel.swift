//
//  WordsViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 08/12/2024.
//

import Foundation
import SwiftUI

class WordsViewModel: ObservableObject {
    @Published var word: String = ""
    @Published var tileColor: [[Color]]
    @Published var wordsToFind: [Word] = []
    @Published var currentMarkedTiles: Set<(CGPoint)> = []
    @Published var isGameOn: Bool = false
    @Published var isGameOver: Bool = false
    @Published var elapsedTime: CGFloat = 0.0
    private let lettersArr: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let wordsNum: Int = 8
    private var lastTile: (Int, Int)?
    private var touchStartTile: (Int, Int)?
    private var timer = Timer()
    let squareSideLenght: Int = 11
    var tileWidth: CGFloat = 30
    var tileLetter: [[Character]]
    var isTouchStart: Bool = false
    
    
    init() {
        tileColor = Array(
            repeating: Array(repeating: .primary, count: squareSideLenght),
            count: squareSideLenght
        )
        tileLetter = Array(repeating: Array(repeating: " ", count: squareSideLenght), count: squareSideLenght)
        tileWidth = adjustTileWidth()
        generateLetters()
    }
    
    func restartTheGame() {
        tileColor = Array(
            repeating: Array(repeating: .primary, count: squareSideLenght),
            count: squareSideLenght
        )
        tileLetter = Array(repeating: Array(repeating: " ", count: squareSideLenght), count: squareSideLenght)
        generateWords()
        putWordsIntoGrid()
        generateLetters()
        elapsedTime = 0.0
        switchOffGameOver()
        isGameOn = true
        startTimer()
    }
    
    func adjustLogoSize() -> CGSize {
        let width = screenSize.width * 0.89
        if width > 550 {return CGSize(width: 550, height: 117)}
        return CGSize(width: width, height: width / 4.71)
    }
    
    func updateTilesState(at location: CGPoint) {
        let row = Int(location.y / (tileWidth + 2))
        let col = Int(location.x / (tileWidth + 2))
        guard
            0 ..< squareSideLenght ~= row,
            0 ..< squareSideLenght ~= col,
            let startPoint = touchStartTile,
            startPoint.0 == row || startPoint.1 == col
        else {
            manageTouchEnd()
            return
        }
        if tileColor[row][col] == .primary {
            addLetterToWord(row: row, col: col)
            tileColor[row][col] = .red
            currentMarkedTiles.insert(CGPoint(x: row, y: col))
            lastTile = (row, col)
        }
        if let lastTile = lastTile, row != lastTile.0 || col != lastTile.1 {
            word.removeLast()
            tileColor[lastTile.0][lastTile.1] = .primary
            currentMarkedTiles.remove(CGPoint(x: lastTile.0, y: lastTile.1))
        }
        lastTile = (row, col)
    }
    
    func defineStartTile(startPoint: CGPoint) {
        let row = Int(startPoint.y / (tileWidth + 2))
        let col = Int(startPoint.x / (tileWidth + 2))
        guard 0 ..< squareSideLenght ~= row && 0 ..< squareSideLenght ~= col else {return}
        touchStartTile = (row, col)
        lastTile = (row, col)
        currentMarkedTiles.insert(CGPoint(x: row, y: col))
    }
    
    func manageTouchEnd() {
        if checkIfWordFound() {
            wordsToFind.removeAll { $0.english == word || $0.english == String(word.reversed())}
            removeLettersFromGrid()
            manageGameover()
        }
        word = ""
        isTouchStart = false
        tileColor = Array(
            repeating: Array(repeating: .primary, count: squareSideLenght),
            count: squareSideLenght
        )
        touchStartTile = nil
        currentMarkedTiles = []
        lastTile = nil
    }
    
    func adjustWordsToFindPadding() -> CGFloat {
        let gridWidth = tileWidth * CGFloat(squareSideLenght) + 20
        return (screenSize.width - gridWidth) / 2
    }
    
    func adjustTileWidth() -> CGFloat {
        let tileWidth = (screenSize.width - 28) / CGFloat(squareSideLenght)
        if tileWidth >= 56 { return 56 }
        return CGFloat(Int(tileWidth))
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.elapsedTime += 0.1
        }
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
    private func switchOnGameOver() {
        withAnimation {
            isGameOver = true
        }
    }
    
    private func switchOffGameOver() {
        withAnimation {
            isGameOver = false
        }
    }
    
    private func checkIfWordFound() -> Bool {
        for w in wordsToFind {
            if w.english == word || w.english == String(word.reversed()) { return true }
        }
        return false
    }
    
    private func addLetterToWord(row: Int, col: Int) {
        word += String(tileLetter[row][col])
    }
    
    private func removeLettersFromGrid() {
        for tile in currentMarkedTiles {
            let row: Int = Int(tile.x)
            let col: Int = Int(tile.y)
            tileLetter[row][col] = " "
        }
    }
    
    private func generateWords() {
        var uniqueWords: Set<Word> = []
        while uniqueWords.count < wordsNum {
            let randWord = WordsData().Words.randomElement()!
            uniqueWords.insert(randWord)
        }
        wordsToFind = Array(uniqueWords)
    }
    
    
    private func generateLetters() {
        for i in 0 ..< squareSideLenght {
            for j in 0 ..< squareSideLenght {
                if tileLetter[i][j] == "*" || tileLetter[i][j] == " " {
                    tileLetter[i][j] = lettersArr.randomElement()!
                }
            }
        }
    }
    
    private func putWordsIntoGrid() {
        for word in wordsToFind {
            var isValidPosition = false
            while !isValidPosition {
                let orientation = Bool.random() ? "Vertical" : "Horizontal"
                let row = Int.random(in: 0 ... squareSideLenght - 1)
                let col = Int.random(in: 0 ... squareSideLenght - 1)
                let range = row ... row + word.english.count - 1
                switch orientation {
                case "Vertical":
                    // Avoiding out of range
                    if range.upperBound >= squareSideLenght { break }
                    
                    // Ensuring there is free space for word
                    if !range.allSatisfy({ tileLetter[$0][col] == " "}) { break }
                    
                    // Placing beggining and ending *
                    if range.lowerBound > 0 {
                        if tileLetter[range.lowerBound - 1][col] != " " { break }
                        tileLetter[range.lowerBound - 1][col] = "*"
                    }
                    if range.upperBound < squareSideLenght - 1 {
                        if tileLetter[range.upperBound + 1][col] != " " { break }
                        tileLetter[range.upperBound + 1][col] = "*"
                        
                    }
                    
                    // Placing the word
                    for j in range {
                        let index = word.english.index(word.english.startIndex, offsetBy: j - row)
                        tileLetter[j][col] = word.english[index]
                    }
                    isValidPosition = true
                case "Horizontal":
                    // Avoiding out of range
                    if range.upperBound >= squareSideLenght { break }
                    
                    // Ensuring there is free space for word
                    if !range.allSatisfy({ tileLetter[row][$0] == " "}) { break }
                    
                    // Placing beggining and ending *
                    if range.lowerBound > 0 {
                        if tileLetter[row][range.lowerBound - 1] != " " { break }
                        tileLetter[row][range.lowerBound - 1] = "*"
                    }
                    if range.upperBound < squareSideLenght - 1 {
                        if tileLetter[row][range.upperBound + 1] != " " { break }
                        tileLetter[row][range.upperBound + 1] = "*"
                        
                    }
                    
                    // Placing the word
                    for j in range {
                        let index = word.english.index(word.english.startIndex, offsetBy: j - row)
                        tileLetter[row][j] = word.english[index]
                    }
                    isValidPosition = true
                default:
                    print("No orientation for the word.")
                }
            }
        }
    }
    
    private func manageGameover() {
        if wordsToFind.isEmpty {
            switchOnGameOver()
            stopTimer()
        }
    }
}


