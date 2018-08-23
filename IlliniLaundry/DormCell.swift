//
//  DormCell.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 01/03/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit

class DormCell: UICollectionViewCell {
    
    @IBOutlet weak var dormImageView: UIImageView!
    @IBOutlet weak var dormLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(dorm: DormStatus) {
        self.dormImageView.image = UIImage(named: dorm.laundry_room_name)
        self.dormLabel.text = dorm.laundry_room_name
    }
}
