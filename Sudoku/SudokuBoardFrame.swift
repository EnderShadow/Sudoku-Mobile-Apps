//
//  SudokuFrame.swift
//  Sudoku
//
//  Created by mwarren on 4/11/16.
//  Copyright © 2016 mwarren. All rights reserved.
//

import UIKit

class SudokuBoardFrame
{
    let sudokuBoard: ViewController
    let index: Int
    var subBoard: SudokuBoardFrame?
    
    init(sudokuBoard: ViewController, index: Int)
    {
        self.sudokuBoard = sudokuBoard
        self.index = index
        if index > 0
        {
            subBoard = SudokuBoardFrame(sudokuBoard: sudokuBoard, index: index - 1)
        }
    }
    
    func tryPossibilities() -> Bool
    {
        var possibilities = sudokuBoard.getPossibilities(index)
        while possibilities.count > 0
        {
            let value = possibilities.removeAtIndex(Int(arc4random_uniform(UInt32(possibilities.count))))
            sudokuBoard.labels[index].value = "\(value)"
            if subBoard == nil
            {
                return true
            }
            else if subBoard!.tryPossibilities()
            {
                return true
            }
        }
        sudokuBoard.labels[index].value = ""
        return false
    }
}