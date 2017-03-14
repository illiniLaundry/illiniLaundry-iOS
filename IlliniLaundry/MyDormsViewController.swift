//

//  MyDormsViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MyDormsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider{
    @IBOutlet weak var MyDormsButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var favorites:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.tintColor = UIColor.gray;
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        self.tableView.separatorStyle  = .none
        tableView.reloadData()
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
    
    func refresh() {
        var favoritesData = UserDefaults.standard.stringArray(forKey: "favorites")
        favoritesData = favoritesData?.sorted()
        if favoritesData != nil {
            favorites = favoritesData!
            print (favorites)
        }
        print ("called refresh")
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favorites.count)
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericFavoritesDormCell", for: indexPath) as! GenericFavoritesDormCell
        
        cell.configure(dorm: favorites[indexPath.section])
        cell.dormNameLabel.allowsDefaultTighteningForTruncation = true
        cell.selectionStyle = .none
        
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.contentView.layer.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.layoutIfNeeded()
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dormView = UIStoryboard(name:"GenericDorm", bundle: nil).instantiateViewController(withIdentifier: "genericDormNavigationController") as! UINavigationController;
        
        GenericDormViewController.dormName = favorites[indexPath.section]
        self.present(dormView, animated:true, completion:nil);
    }
}
