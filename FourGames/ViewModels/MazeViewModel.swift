//
//  MazeViewModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 22/12/2024.
//

import Foundation
import SwiftUI

// 0 - path, 1 - wall, 2 - start, 3 - finish, 4 - touched
class MazeViewModel: ObservableObject {
    @Published var mazeArr: [[Character]]
    @Published var isGameOn: Bool = false
    @Published var isGameOver: Bool = false
    @Published var elapsedTime: CGFloat = 0.0
    @Published var isAlertOn: Bool = false
    @Published var alertText: String = ""
    private var mazeArrOG: [[Character]]
    private var lastTile: (Int, Int)?
    private var currentMarkedTiles: [(Int, Int)] = []
    private var timer = Timer()
    let mazeSize: Int = 17
    var tileWidth: CGFloat = 20
    var maze: Maze
    var startTile: (Int, Int) = (0, 0)
    var endTile: (Int, Int) = (0, 0)
    var isTouchStart: Bool = false
    
    init() {
        maze = Maze(width: mazeSize, height: mazeSize)
        mazeArr = maze.outputMaze()
        mazeArrOG = maze.outputMaze()
        mazeArrOG = mazeArr
        tileWidth = adjustTileSize()
    }
    
    func adjustLogoSize() -> CGSize {
        let width = screenSize.width * 0.89
        if width > 550 {return CGSize(width: 550, height: 117)}
        return CGSize(width: width, height: width / 4.71)
    }
    
    func manageSolving(at location: CGPoint) {
        let row = Int(location.y / tileWidth)
        let col = Int(location.x / tileWidth)
        guard 0 ..< mazeSize ~= row && 0 ..< mazeSize ~= col else {
            manageTouchEnd()
            return
        }
        if let firstPoint = currentMarkedTiles.first {
            guard firstPoint == startTile else {
                manageTouchEnd()
                return
            }
        }
        let currentNum = mazeArr[row][col]
        if currentNum == "1" {
            if let lastTile = lastTile {
                let lastTilePos = CGPoint(x: CGFloat(lastTile.1) * tileWidth + tileWidth / 2, y: CGFloat(lastTile.0) * tileWidth + tileWidth / 2)
                if distanceBetweenPoints(location, lastTilePos) > tileWidth {
                    manageTouchEnd()
                }
            }
        }
        else if currentNum == "0" || currentNum == "2" || currentNum == "3" {
            if let lastTile = lastTile {
                if lastTile.0 != row && lastTile.1 != col {
                    manageTouchEnd()
                }
            }
            if !currentMarkedTiles.contains(where: { $0 == (row, col)}) {
                currentMarkedTiles.append((row, col))
            }
            mazeArr[row][col] = "4"
            lastTile = (row, col)
            print(lastTile!)
        }
        else if currentNum == "4" {
            if let lastTile = lastTile, row != lastTile.0 || col != lastTile.1 {
                mazeArr[lastTile.0][lastTile.1] = "0"
                currentMarkedTiles.removeLast()
            }
            lastTile = (row, col)
        }
    }
    
    func manageTouchEnd() {
        mazeArr = mazeArrOG
        currentMarkedTiles = []
        isTouchStart = false
    }
    
    func checkIfMazeSolved() {
        guard currentMarkedTiles.count > 1 else {return}
        guard currentMarkedTiles.first! == startTile && currentMarkedTiles.last! == endTile else {return}
        switchOnGameOver()
        stopTimer()
    }
    
    func adjustIconOffset(tilePos: (Int, Int)) -> (CGFloat, CGFloat) {
        let initPos = (9, 9)
        let offsetRow = tilePos.0 - initPos.0 + 1
        let offsetCol = tilePos.1 - initPos.1 + 1
        return (CGFloat(offsetRow) * tileWidth, CGFloat(offsetCol) * tileWidth)
    }
    
    func restartTheGame() {
        maze = Maze(width: mazeSize, height: mazeSize)
        mazeArr = maze.outputMaze()
        mazeArrOG = maze.outputMaze()
        pickRandomStartEndPoints()
        mazeArrOG = mazeArr
        elapsedTime = 0.0
        switchOffGameOver()
        isGameOn = true
        startTimer()
    }
    
    private func adjustTileSize() -> CGFloat {
        let tileWidth = (screenSize.width - 2) / CGFloat(mazeSize)
        if tileWidth >= 38 { return 38 }
        return tileWidth
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
    
    private func pickRandomStartEndPoints() {
        var arePointsFound = false
        var startPoint = (1,0)
        var endPoint = (mazeSize - 2, mazeSize - 1)
        while !arePointsFound {
            let orientation = Bool.random() ? "horizontal" : "vertical"
            let pointFirst = Int.random(in: 1 ... mazeSize - 2)
            let pointSecond = Bool.random() ? 0 : mazeSize - 1
            
            if orientation == "horizontal" {
                endPoint.0 = (0 ..< Int(mazeSize / 2)).contains(pointFirst)
                    ? Int.random(in: Int(mazeSize / 2) ... mazeSize - 1)
                    : Int.random(in: 0 ..< Int(mazeSize / 2))
                endPoint.1 = pointSecond == 0 ? mazeSize - 1 : 0
            } else {
                endPoint.1 = (0 ..< Int(mazeSize / 2)).contains(pointFirst)
                    ? Int.random(in: Int(mazeSize / 2) ... mazeSize - 1)
                    : Int.random(in: 0 ..< Int(mazeSize / 2))
                endPoint.0 = pointSecond == 0 ? mazeSize - 1 : 0
            }

            
            
            if orientation == "horizontal" {
                if pointSecond == 0 {
                    guard checkIsPath(point: (pointFirst, pointSecond + 1)) && checkIsPath(point: (endPoint.0, endPoint.1 - 1)) else { continue }
                }
                else {
                    guard checkIsPath(point: (pointFirst, pointSecond - 1)) && checkIsPath(point: (endPoint.0, endPoint.1 + 1)) else { continue }
                }
                startPoint = (pointFirst, pointSecond)
            }
            else {
                if pointSecond == 0 {
                    guard checkIsPath(point: (pointSecond + 1, pointFirst)) && checkIsPath(point: (endPoint.1, endPoint.0 - 1)) else { continue }
                }
                else {
                    guard checkIsPath(point: (pointSecond - 1, pointFirst)) && checkIsPath(point: (endPoint.1, endPoint.0 + 1)) else { continue }
                }
                startPoint = (pointSecond, pointFirst)
            }
            arePointsFound = true
        }
        mazeArr[startPoint.0][startPoint.1] = "2"
        mazeArr[endPoint.0][endPoint.1] = "3"
        startTile = startPoint
        endTile = endPoint
    }
    
    private func checkIsPath(point: (Int, Int)) -> Bool {
        if mazeArr[point.0][point.1] == "0" {return true}
        return false
    }
    
    private func distanceBetweenPoints(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            return sqrt(dx * dx + dy * dy)
        
    }
}
