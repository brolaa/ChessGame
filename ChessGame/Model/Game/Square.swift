//
//  Square.swift
//  ChessGame
//
//  Created by Bartosz Rola on 24/11/2024.
//

import Foundation

struct Square: Equatable, Decodable {
    let row: Int
    let col: Int
    
    func translateSquare() -> String {
        let xAxis = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let yAxis = [8, 7, 6, 5, 4, 3, 2, 1]
        
        return "\(xAxis[col])\(yAxis[row])"
    }
}
