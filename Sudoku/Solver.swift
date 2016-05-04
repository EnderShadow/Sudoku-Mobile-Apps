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
        if !revertAfterSolve
        {
            sudokuBoard.labels.filter({$0.chosenValueLabel.enabled}).forEach({$0.value = ""})
        }
        var emptyIndices: [Int] = []
        for i in 0..<81
        {
            if sudokuBoard.labels[i].value!.isEmpty
            {
                emptyIndices.append(i)
            }
        }
        let origEmptyIndices = emptyIndices
        
        let iterationsMax = emptyIndices.count
        var iterations = 0
        while emptyIndices.count > 0 && iterations < iterationsMax
        {
            for (index, value) in emptyIndices.enumerate().reverse()
            {
                let possibilities = sudokuBoard.getPossibilities(value)
                if possibilities.count == 1
                {
                    sudokuBoard.labels[value].value = "\(possibilities[0])"
                    emptyIndices.removeAtIndex(index)
                }
            }
            iterations += 1
        }
        
        let success = emptyIndices.count == 0
        
        if revertAfterSolve
        {
            for i in origEmptyIndices
            {
                sudokuBoard.labels[i].value = ""
            }
        }
        
        return success
    }
}