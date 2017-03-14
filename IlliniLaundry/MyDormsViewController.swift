//

//  MyDormsViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyDormsViewController: UIViewController, IndicatorInfoProvider{
    @IBOutlet weak var MyDormsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Dorms")
    }
    
    @IBAction func DormView(_ sender: Any) {
        let dormView = UIStoryboard(name:"GenericDorm", bundle: nil).instantiateViewController(withIdentifier: "genericDormNavigationController");
        self.present(dormView, animated:true, completion:nil);
    }
}
