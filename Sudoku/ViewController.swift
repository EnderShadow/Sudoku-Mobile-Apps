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
    var showValues = true
    
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
            label.addGestureRecognizer(UITapGestureRecognizer(target: label, action: #selector(label.onTap)))
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
        
        var middle = labels[76].frame.origin
        middle.x += labels[76].frame.width / 2
        middle.y += labels[76].frame.height * 1.75
        
        //let modeButton = UIButton()
        //modeButton.setTitle("Toggle Mode", forState: .Normal)
        //modeButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        //modeButton.titleLabel?.textAlignment = .Center
        //modeButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        //modeButton.frame = CGRect(x: middle.x - 160, y: middle.y, width: 100, height: 5)
        //modeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleCells)))
        
        let clearButton = UIButton()
        clearButton.setTitle("Clear Board", forState: .Normal)
        clearButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        clearButton.titleLabel?.textAlignment = .Center
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        clearButton.frame = CGRect(x: middle.x - 160, y: middle.y, width: 100, height: 5)
        clearButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clearBoard)))
        
        let newGridButton = UIButton()
        newGridButton.setTitle("New Board", forState: .Normal)
        newGridButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        newGridButton.titleLabel?.textAlignment = .Center
        newGridButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        newGridButton.frame = CGRect(x: middle.x - 50, y: middle.y, width: 100, height: 5)
        newGridButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.newBoard)))
        
        let solveButton = UIButton()
        solveButton.setTitle("Solve for Me", forState: .Normal)
        solveButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        solveButton.titleLabel?.textAlignment = .Center
        solveButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        solveButton.frame = CGRect(x: middle.x + 60, y: middle.y, width: 100, height: 5)
        solveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.solve)))
        
        let checkButton = UIButton()
        checkButton.setTitle("Check Me", forState: .Normal)
        checkButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        checkButton.titleLabel?.textAlignment = .Center
        checkButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        checkButton.frame = CGRect(x: middle.x - 50, y: middle.y + 30, width: 100, height: 5)
        checkButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkGrid)))
        
        //view.addSubview(modeButton)
        view.addSubview(clearButton)
        view.addSubview(newGridButton)
        view.addSubview(solveButton)
        view.addSubview(checkButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        
        generatePuzzle()
    }
    
    func toggleCells()
    {
        labels.filter({($0.chosenValueLabel.text!.isEmpty && showValues) || $0.chosenValueLabel.hidden}).forEach({$0.toggleMode()})
        showValues = !showValues
    }
    
    func clearBoard()
    {
        let confirmController = UIAlertController(title: "Are you sure you want to clear the board?", message: nil, preferredStyle: .Alert)
        confirmController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            self.labels.filter({$0.chosenValueLabel.enabled}).forEach({$0.chosenValueLabel.text = ""})
        }))
        confirmController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        presentViewController(confirmController, animated: true, completion: nil)
    }
    
    func newBoard()
    {
        let confirmController = UIAlertController(title: "Are you sure you want to get a new board?", message: nil, preferredStyle: .Alert)
        confirmController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            self._newBoard()
        }))
        confirmController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        presentViewController(confirmController, animated: true, completion: nil)
        
    }
    
    func _newBoard()
    {
        let generatingController = UIAlertController(title: nil, message: "Generating new board", preferredStyle: .Alert)
        presentViewController(generatingController, animated: true, completion: {
            self.labels.forEach({$0.reset()})
            self.generatePuzzle()
            generatingController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func solve()
    {
        let confirmController = UIAlertController(title: "Are you sure you want to see the solution?", message: nil, preferredStyle: .Alert)
        confirmController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            Solver.solve(self, revertAfterSolve: false)
        }))
        confirmController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        presentViewController(confirmController, animated: true, completion: nil)
    }
    
    func checkGrid()
    {
        let valid = isValid()
        if valid != nil && valid!
        {
            let winController = UIAlertController(title: "Congratulations", message: "You won!", preferredStyle: .Alert)
            winController.addAction(UIAlertAction(title: "New Game", style: .Default, handler: { (action) in
                self._newBoard()
            }))
            winController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(winController, animated: true, completion: nil)
        }
        else if Solver.solve(self) && !isInvalid()
        {
            let progressController = UIAlertController(title: "Doing good", message: "So far so good.", preferredStyle: .Alert)
            progressController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(progressController, animated: true, completion: nil)
        }
        else
        {
            let loseController = UIAlertController(title: "Sorry", message: "This isn't correct", preferredStyle: .Alert)
            loseController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(loseController, animated: true, completion: nil)
        }
    }
    
    func hideKeyboard()
    {
        labels.forEach({$0.chosenValueLabel.resignFirstResponder()})
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
        let frame = SudokuBoardFrame(sudokuBoard: self, index: 80)
        frame.tryPossibilities()
        
        print(labels.map({$0.value!}))
        
        // create holes
        var filledSlots = Array(0..<81)
        for _ in 0..<(20 + Int(arc4random_uniform(UInt32(60))))
        {
            let _index = Int(arc4random_uniform(UInt32(filledSlots.count)))
            let index = filledSlots[_index]
            let oldVal = labels[index].value
            labels[index].value = ""
            if !Solver.solve(self)
            {
                labels[index].value = oldVal
            }
            else
            {
                filledSlots.removeAtIndex(_index)
            }
        }
        labels.filter({$0.value!.isEmpty}).forEach({$0.chosenValueLabel.enabled = true; $0.font = UIFont.systemFontOfSize($0.font.pointSize)})
        labels.filter({!$0.value!.isEmpty}).forEach({$0.chosenValueLabel.enabled = false; $0.font = UIFont.boldSystemFontOfSize($0.font.pointSize)})
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