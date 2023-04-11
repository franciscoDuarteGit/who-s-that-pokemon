//
//  GameModel.swift
//  who's that pokemon
//
//  Created by Usuario on 29/03/23.
// modelo del juego con funcionalidades

import Foundation


struct GameModel {
    var score = 0
    
    //Revisar respuesta correcta
    mutating func checkAnswer(_ userAnswer: String, _ correctAnswer: String) -> Bool {
        if userAnswer.lowercased() == correctAnswer.lowercased(){
            score += 1
            return true
        }
        return false
    }
    
    // obtener Score
    func getScore() -> Int {
        return score
    }
    
    // reiniciar Score
    // mutating para cambiar los valores, debido a que en una structura no se mutan los valores, self es inmutable
    mutating func setScore(score: Int) {
        self.score = score
    }
    
    
}
