//
//  CustomCell.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 8/5/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func updateCustomSell(data: CellData) {
        
        titleLabel.text = data.title
        if data.score != "-" {
            scoreLabel.text = data.score + "%"
        } else {
            scoreLabel.text = data.score
        }
        scoreLabel.textColor = UIColor(red: 20.0/255.0, green: 142.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        if data.score == "-" {
            scoreLabel.textColor = UIColor.black
        } else {
            if Int(data.score)! < 75 {
                scoreLabel.textColor = UIColor.red
            }
        }
    }
    
}
