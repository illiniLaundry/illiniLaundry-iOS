//
//  OneDormCell.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 28/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit

class OneDormCell: UITableViewCell {
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(first: DormStatus) {
        self.firstImageView.image = UIImage(named: first.name)
        self.firstLabel.text = first.name
    }
}
