//
//  Cube.swift
//  CubeNet
//
//  Created by Maya Luna Celeste on 8/23/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa

class Cube: NSObject {
    
    enum MoveType {
        case up
        case down
        case right
        case left
        case front
        case back
    }
    
    var stringValue = "yyyybbbboooorrrrggggwwww"
    var remainingMoves = 50
    var cubeActive = true
    
    
    func turn(_ type : MoveType, prime : Bool) {
        var state = Array(stringValue)
        
        if prime {
            switch type {
            case MoveType.up:
                state.swapAt(0, 3)
                state.swapAt(0, 2)
                state.swapAt(0, 1)
                state.swapAt(5, 13)
                state.swapAt(5, 17)
                state.swapAt(5, 9)
                state.swapAt(4, 12)
                state.swapAt(4, 16)
                state.swapAt(4, 8)
            case MoveType.down:
                state.swapAt(20, 23)
                state.swapAt(20, 22)
                state.swapAt(20, 21)
                state.swapAt(6, 10)
                state.swapAt(6, 18)
                state.swapAt(6, 14)
                state.swapAt(7, 11)
                state.swapAt(7, 19)
                state.swapAt(7, 15)
            case MoveType.right:
                state.swapAt(1, 5)
                state.swapAt(1, 21)
                state.swapAt(1, 19)
                state.swapAt(2, 6)
                state.swapAt(2, 22)
                state.swapAt(2, 16)
                state.swapAt(12, 15)
                state.swapAt(12, 14)
                state.swapAt(12, 13)
            case MoveType.left:
                state.swapAt(0, 18)
                state.swapAt(0, 20)
                state.swapAt(0, 4)
                state.swapAt(3, 17)
                state.swapAt(3, 23)
                state.swapAt(3, 7)
                state.swapAt(8, 11)
                state.swapAt(8, 10)
                state.swapAt(8, 9)
            case MoveType.front:
                state.swapAt(2, 9)
                state.swapAt(2, 20)
                state.swapAt(2, 15)
                state.swapAt(3, 10)
                state.swapAt(3, 21)
                state.swapAt(3, 12)
                state.swapAt(4, 7)
                state.swapAt(4, 6)
                state.swapAt(4, 5)
            case MoveType.back:
                state.swapAt(0, 13)
                state.swapAt(0, 22)
                state.swapAt(0, 11)
                state.swapAt(1, 14)
                state.swapAt(1, 23)
                state.swapAt(1, 8)
                state.swapAt(16, 19)
                state.swapAt(16, 18)
                state.swapAt(16, 17)
            }
        } else {
            switch type {
            case MoveType.up:
                state.swapAt(0, 1)
                state.swapAt(0, 2)
                state.swapAt(0, 3)
                state.swapAt(5, 9)
                state.swapAt(5, 17)
                state.swapAt(5, 13)
                state.swapAt(4, 8)
                state.swapAt(4, 16)
                state.swapAt(4, 12)
            case MoveType.down:
                state.swapAt(20, 21)
                state.swapAt(20, 22)
                state.swapAt(20, 23)
                state.swapAt(6, 14)
                state.swapAt(6, 18)
                state.swapAt(6, 10)
                state.swapAt(7, 15)
                state.swapAt(7, 19)
                state.swapAt(7, 11)
            case MoveType.right:
                state.swapAt(1, 19)
                state.swapAt(1, 21)
                state.swapAt(1, 5)
                state.swapAt(2, 16)
                state.swapAt(2, 22)
                state.swapAt(2, 6)
                state.swapAt(12, 13)
                state.swapAt(12, 14)
                state.swapAt(12, 15)
            case MoveType.left:
                state.swapAt(0, 4)
                state.swapAt(0, 20)
                state.swapAt(0, 18)
                state.swapAt(3, 7)
                state.swapAt(3, 23)
                state.swapAt(3, 17)
                state.swapAt(8, 9)
                state.swapAt(8, 10)
                state.swapAt(8, 11)
            case MoveType.front:
                state.swapAt(2, 15)
                state.swapAt(2, 20)
                state.swapAt(2, 9)
                state.swapAt(3, 12)
                state.swapAt(3, 21)
                state.swapAt(3, 10)
                state.swapAt(4, 5)
                state.swapAt(4, 6)
                state.swapAt(4, 7)
            case MoveType.back:
                state.swapAt(0, 11)
                state.swapAt(0, 22)
                state.swapAt(0, 13)
                state.swapAt(1, 8)
                state.swapAt(1, 23)
                state.swapAt(1, 14)
                state.swapAt(16, 17)
                state.swapAt(16, 18)
                state.swapAt(16, 19)
            }
        }
        
        stringValue = String(state)
        print(stringValue)
        print(fitness())
        print(inputs())
        if remainingMoves > 0 { remainingMoves -= 1 }
        if remainingMoves == 0 { cubeActive = false }
    }
    
    func fitness() -> Double{
        let side = Array(stringValue)[20...23]
        var fitness : Double = 0
        if side == ["w","w","w","w"] {
            fitness = pow(Double(remainingMoves), 2) + 4
        } else {
            for piece in side {
                if piece == "w" { fitness += 1 }
            }
        }
        
        return fitness
    }
    
    func inputs() -> [Double] {
        var inputs : [Double] = []
        let state = Array(stringValue)
        for color in state {
            inputs.append(color == "w" ? 1 : 0)
        }
        return inputs
    }
    
    
}
