//
//  GenericDormViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class GenericDormViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let kTableHeaderHeight: CGFloat = 300.0;
    
    var previousScrollOffset: CGFloat = 0;
    var headerView: UIView!;
    var hideStatusBar: Bool = false;

    var dorms = [DormStatus]();
    
    @IBOutlet weak var dormImageView: UIImageView!;
    @IBOutlet weak var dormNameLabel: UILabel!;
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        headerView = tableView.tableHeaderView;
        tableView.tableHeaderView = nil;
        
        tableView.addSubview(headerView);
        
        tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight);
        updateHeaderView();
        
        loadSavedData();
        
        DispatchQueue.global(qos: .background).async { [weak self]
            () -> Void in
            CoreDataHelpers.fetchLaundryStatus();
            DispatchQueue.main.async {
                () -> Void in
                self?.loadSavedData();
            }
        }

        
        //on completion loadSavedData();
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dorms.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath) as! LaundryMachineCell;
        
        let dorm = dorms[indexPath.row];
        cell.DormNameLabel.text = dorm.name;
        return cell;
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect

    }
    
    func loadSavedData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
        let request = DormStatus.createFetchRequest();
        let sort = NSSortDescriptor(key: "name", ascending: true);
        request.sortDescriptors = [sort];
        
        do {
            dorms = try container.viewContext.fetch(request);
            tableView.reloadData();
            print("table reloaded");
        } catch {
            print("Fetch failed");
        }
    }
    
    

}


