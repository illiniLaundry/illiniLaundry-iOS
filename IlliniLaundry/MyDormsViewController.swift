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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favorites.count)
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericFavoritesDormCell", for: indexPath) as! GenericFavoritesDormCell
        
        cell.dormNameLabel.text = favorites[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dormView = UIStoryboard(name:"GenericDorm", bundle: nil).instantiateViewController(withIdentifier: "genericDormNavigationController") as! UINavigationController;
        
        GenericDormViewController.dormName = favorites[indexPath.row]
        self.present(dormView, animated:true, completion:nil);
    }
}
