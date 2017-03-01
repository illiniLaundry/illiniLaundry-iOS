//
//  TwoDormCell.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 28/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit

class TwoDormCell: UITableViewCell {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(first: DormStatus, second: DormStatus) {
        self.firstImageView.image = UIImage(named: first.name)
        self.secondImageView.image = UIImage(named: second.name)
        self.firstLabel.text = first.name
        self.secondLabel.text = second.name
    }
}
