//
//  Word.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 08/12/2024.
//

import Foundation

struct Word: Identifiable, Hashable{
    let english: String
    let polish: String
    var id: String{
        return english
    }
}
