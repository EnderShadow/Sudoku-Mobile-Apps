//
//  ViewController.swift
//  Sudoku
//
//  Created by mwarren on 4/5/16.
//  Copyright © 2016 mwarren. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var labels : [SudokuCell] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let size = Int(min(view.frame.width, view.frame.height) / 11)
        for i in 0..<81
        {
            let label = SudokuCell(frame: CGRect(x: i % 9 * size + size, y: i / 9 * size + size, width: size, height: size))
            label.font = label.font.fontWithSize(24)
            labels.append(label)
        }
        labels.forEach { label in
            view.addSubview(label)
        }
        
        for i in 0...9
        {
            let thickness = i % 3 == 0 ? 4 : 2
            var line = UIView(frame: CGRect(x: i * size + size - thickness / 2, y: size, width: thickness, height: 9 * size + thickness))
            line.backgroundColor = UIColor.blackColor()
            view.addSubview(line)
            
            line = UIView(frame: CGRect(x: size, y: i * size + size, width: 9 * size + thickness - thickness / 2, height: thickness))
            line.backgroundColor = UIColor.blackColor()
            view.addSubview(line)
        }
        
        generatePuzzle()
    }
    
    func getRow(index: Int) -> [Int]
    {
        var tempList: [Int] = []
        for i in 0..<9
        {
            if !labels[index * 9 + i].value!.isEmpty
            {
                tempList.append(Int(labels[index * 9 + i].value!)!)
            }
        }
        return tempList
    }
    
    func getColumn(index: Int) -> [Int]
    {
        var tempList: [Int] = []
        for i in 0..<9
        {
            if !labels[i * 9 + index].value!.isEmpty
            {
                tempList.append(Int(labels[i * 9 + index].value!)!)
            }
        }
        return tempList
    }
    
    func getBlock(index: Int) -> [Int]
    {
        let x = index % 3 * 3
        let y = index / 3 * 3
        var tempList: [Int] = []
        for i in 0..<3
        {
            for j in 0..<3
            {
                if !labels[(y + i) * 9 + x + j].value!.isEmpty
                {
                    tempList.append(Int(labels[(y + i) * 9 + x + j].value!)!)
                }
            }
        }
        return tempList
    }
    
    func getRowCells(index: Int) -> [SudokuCell]
    {
        var tempList: [SudokuCell] = []
        for i in 0..<9
        {
            tempList.append(labels[index * 9 + i])
        }
        return tempList
    }
    
    func getColumnCells(index: Int) -> [SudokuCell]
    {
        var tempList: [SudokuCell] = []
        for i in 0..<9
        {
                tempList.append(labels[i * 9 + index])
        }
        return tempList
    }
    
    func getBlockCells(index: Int) -> [SudokuCell]
    {
        let x = index % 3 * 3
        let y = index / 3 * 3
        var tempList: [SudokuCell] = []
        for i in 0..<3
        {
            for j in 0..<3
            {
                tempList.append(labels[(y + i) * 9 + x + j])
            }
        }
        return tempList
    }
    
    func isValid() -> Bool?
    {
        for label in labels
        {
            if(label.chosenValueLabel.text!.isEmpty)
            {
                return nil
            }
        }
        for i in 0..<9
        {
            if !isValid(getRow(i)) || !isValid(getColumn(i)) || !isValid(getBlock(i))
            {
                return false
            }
        }
        return true
    }
    
    func isValid(values: [Int]) -> Bool
    {
        let correctCount = Set(values).count == 9
        let correctValues = values.filter({$0 > 0 && $0 <= 9}).count == 9
        return correctCount && correctValues
    }
    
    func isInvalid() -> Bool
    {
        for i in 0..<9
        {
            if isInvalid(getRow(i)) || isInvalid(getColumn(i)) || isInvalid(getBlock(i))
            {
                return true
            }
        }
        return false
    }
    
    func isInvalid(values: [Int]) -> Bool
    {
        let differentCount = Set(values).count != values.count
        let illegalValues = values.filter({$0 <= 0 || $0 > 9}).count > 0
        return differentCount || illegalValues
    }
    
    func generatePuzzle()
    {
        var frame = SudokuBoardFrame(sudokuBoard: self, index: 80)
        frame.tryPossibilities()
        
        print(labels.map({$0.value!}))
        
        // TODO create holes
    }
    
    func getPossibilities(index: Int) -> [Int]
    {
        return getPossibilities(index % 9, y: index / 9)
    }
    
    func getPossibilities(x: Int, y: Int) -> [Int]
    {
        let row = Set(getRow(y))
        let col = Set(getColumn(x))
        let block = Set(getBlock(y / 3 * 3 + x / 3))
        return Array(row.union(col).union(block).exclusiveOr(Set(arrayLiteral: 1, 2, 3, 4, 5, 6, 7, 8, 9)))
    }
}