//
//  SudokuCell.swift
//  Sudoku
//
//  Created by mwarren on 4/6/16.
//  Copyright © 2016 mwarren. All rights reserved.
//

import UIKit

class SudokuCell: UIView
{
    var value: String? {
        set
        {
            chosenValueLabel.text = newValue
        }
        get
        {
            return chosenValueLabel.text
        }
    }
    var _possibilitiesVisible = Array(count: 9, repeatedValue: false)
    var font: UIFont {
        set
        {
            chosenValueLabel.font = newValue
            potentialValueLabels.forEach({$0.font = newValue.fontWithSize(newValue.pointSize / 2)})
        }
        get
        {
            return chosenValueLabel.font
        }
    }
    
    var chosenValueLabel: UILabel!
    var potentialValueLabels: [UILabel] = []
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        chosenValueLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 60, height: 60))
        chosenValueLabel.text = ""
        chosenValueLabel.textAlignment = NSTextAlignment.Center
        chosenValueLabel.adjustsFontSizeToFitWidth = true
        addSubview(chosenValueLabel)
        
        for i in 0..<9
        {
            let label = UILabel(frame: CGRect(x: i % 3 * 40, y: i / 3 * 40, width: 40, height: 40))
            label.text = "\(i + 1)"
            label.textAlignment = NSTextAlignment.Center
            label.adjustsFontSizeToFitWidth = true
            label.hidden = true
            potentialValueLabels.append(label)
            addSubview(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        chosenValueLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 60, height: 60))
        chosenValueLabel.text = "0"
        chosenValueLabel.textAlignment = NSTextAlignment.Center
        chosenValueLabel.adjustsFontSizeToFitWidth = true
        addSubview(chosenValueLabel)
        
        for i in 0..<9
        {
            let label = UILabel(frame: CGRect(x: i % 3 * 40, y: i / 3 * 40, width: 40, height: 40))
            label.text = "\(i + 1)"
            label.textAlignment = NSTextAlignment.Center
            label.adjustsFontSizeToFitWidth = true
            label.hidden = true
            potentialValueLabels.append(label)
            addSubview(label)
        }
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 120, height: 120)
    }
    
    override func layoutSubviews()
    {
        chosenValueLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        potentialValueLabels.forEach { (label) in
            let multiplier = self.frame.width / 3 / label.frame.width
            label.frame = CGRect(x: label.frame.minX * multiplier, y: label.frame.minY * multiplier, width: label.frame.width * multiplier, height: label.frame.height * multiplier)
        }
    }
    
    func togglePossibility(value: Int)
    {
        if chosenValueLabel.hidden
        {
            potentialValueLabels[value - 1].hidden = _possibilitiesVisible[value - 1]
        }
        _possibilitiesVisible[value - 1] = !_possibilitiesVisible[value - 1]
    }
    
    func toggleMode()
    {
        if chosenValueLabel.hidden
        {
            potentialValueLabels.forEach({$0.hidden = true})
            chosenValueLabel.hidden = false
        }
        else
        {
            chosenValueLabel.hidden = true
            for i in 0..<9
            {
                potentialValueLabels[i].hidden = !_possibilitiesVisible[i]
            }
        }
    }
}