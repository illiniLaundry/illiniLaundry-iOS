//
//  LaundryMachineCell.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 07/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit

class LaundryMachineCell: UITableViewCell {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    func configure(dorm: DormMachines) {
        self.numberLabel.text = dorm.label.description
        self.typeLabel.text = dorm.description_
        self.statusLabel.text = dorm.status
        self.timeRemainingLabel.text = dorm.timeRemaining
        
        if(dorm.status != "Available") {
            let background = UIView(frame: self.frame)
            background.backgroundColor = hexToUIColor(softRed)
            self.backgroundView = background
        } else {
            let background = UIView(frame: self.frame)
            background.backgroundColor = hexToUIColor(softGreen)
            self.backgroundView = background
        }
        
        self.numberLabel.textColor = hexToUIColor(textGray)
        self.typeLabel.textColor = hexToUIColor(textGray)
        self.statusLabel.textColor = hexToUIColor(textGray)
        self.timeRemainingLabel.textColor = hexToUIColor(textGray)
        
    }
}
