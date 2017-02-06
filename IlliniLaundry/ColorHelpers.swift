//
//  ColorHelpers.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//


import UIKit

func hexToUIColor(_ number: Int) -> UIColor {
    let r = CGFloat(number >> 16) / 255
    let g = CGFloat((number >> 8) & 0xFF) / 255
    let b = CGFloat(number & 0xFF) / 255
  
    return UIColor.init(red: r, green: g, blue: b, alpha: 1)
}

