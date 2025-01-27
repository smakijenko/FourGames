//
//  UserScoresDataModel.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 27/01/2025.
//

import Foundation

struct UserScoresDataModel {
    let uid: String
    let runScore: Int
    let wordsScore: Double
    let mazeScore: Double
    let towerScore: Int

    init(uid: String, runScore: Int, wordsScore: Double, mazeScore: Double, towerScore: Int) {
        self.uid = uid
        self.runScore = towerScore
        self.wordsScore = wordsScore
        self.mazeScore = mazeScore
        self.towerScore = towerScore
    }
}
