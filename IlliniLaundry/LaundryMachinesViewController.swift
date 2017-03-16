//
//  LaundryMachineViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LaundryMachineViewController: ButtonBarPagerTabStripViewController {
    
    
    let selectedBarColor = hexToUIColor(IllinoisOrange)

    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = hexToUIColor(IllinoisBlue)
        settings.style.selectedBarBackgroundColor = selectedBarColor
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemFont = UIFont(name: "Avenir", size: 18)!
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = self?.selectedBarColor
        }
        super.viewDidLoad()
        
        self.view.backgroundColor = hexToUIColor(IllinoisBlue)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let AllDormsTab = UIStoryboard(name: "Dorms", bundle: nil).instantiateViewController(withIdentifier: "AllDormsTab");
        let MyDormsTab = UIStoryboard(name: "Dorms",  bundle: nil).instantiateViewController(withIdentifier: "MyDormsTab");
        return [AllDormsTab, MyDormsTab];
    }
}

