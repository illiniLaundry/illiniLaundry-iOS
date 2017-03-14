//
//  GenericFavoritesDormCell.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 14/03/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit

class GenericFavoritesDormCell: UITableViewCell {
    
    
    @IBOutlet weak var dormImageView: UIImageView!
    @IBOutlet weak var dormNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    func configure(dorm: String) {
        self.dormImageView.image = UIImage(named: dorm)
        self.dormNameLabel.text = dorm
    }

}
