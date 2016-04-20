//
//  Solver.swift
//  Sudoku
//
//  Created by mwarren on 4/14/16.
//  Copyright © 2016 mwarren. All rights reserved.
//

import UIKit

class Solver
{
    static func solve(sudokuBoard: ViewController, revertAfterSolve: Bool = true) -> Bool
    {
        var emptyIndices: [Int] = []
        let origEmptyIndices = emptyIndices
        for i in 0..<81
        {
            if sudokuBoard.labels[i].value!.isEmpty
            {
                emptyIndices.append(i)
            }
        }
        
        let iterationsMax = emptyIndices.count
        var iterations = 0
        while emptyIndices.count > 0 && iterations < iterationsMax
        {
            for var i = 0; i < emptyIndices.count; i += 1
            {
                let value = emptyIndices[i]
                let possibilities = sudokuBoard.getPossibilities(value)
                if possibilities.count == 1
                {
                    sudokuBoard.labels[value].value = "\(possibilities[0])"
                    emptyIndices.removeAtIndex(i)
                    i -= 1
                }
            }
            iterations += 1
        }
        
        let success = emptyIndices.count == 0
        
        for i in origEmptyIndices
        {
            sudokuBoard.labels[i].value = ""
        }
        
        return success
    }
}