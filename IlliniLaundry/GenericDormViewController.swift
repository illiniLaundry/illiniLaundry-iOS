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

class GenericDormViewController: UITableViewController {
    
    let kTableHeaderHeight: CGFloat = 300.0;
    
    var previousScrollOffset: CGFloat = 0;
    var headerView: UIView!;
    var hideStatusBar: Bool = false;
    var container: NSPersistentContainer!;
    
    @IBOutlet weak var dormImageView: UIImageView!;
    @IBOutlet weak var dormNameLabel: UILabel!;
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        loadPersistentStores();
        
        headerView = tableView.tableHeaderView;
        tableView.tableHeaderView = nil;
        
        tableView.addSubview(headerView);
        
        tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight);
        updateHeaderView();
        performSelector(inBackground: #selector(fetchLaundryStatus), with: nil)
        
        
    }
    
    func fetchLaundryStatus() {
        if let data = try? Data(contentsOf: URL(string: "http://23.23.147.128/homes/mydata/urba7723")!) {
            let jsonUIUC = JSON(data: data)
            let dormJSONArray = jsonUIUC["rooms"].arrayValue;
            
            
            DispatchQueue.main.async { [unowned self] in
                for dormJSON in dormJSONArray {
                    let dormStatus = DormStatus(context: self.container.viewContext);
                  
                    self.configure(dormStatus: dormStatus, usingJSON: dormJSON);
                }
                
                self.saveContext()
            }
        }
    }
    func configure(dormStatus: DormStatus,
                   usingJSON dormJson: JSON) {
        dormStatus.id = dormJson["id"].int16Value;
        dormStatus.name = dormJson["name"].stringValue;
        dormStatus.networked = dormJson["networked"].stringValue;
        dormStatus.dormMachines = dormJson["machines"];
    }
    func loadPersistentStores() {
        container = NSPersistentContainer(name: "Dorm");
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Unresolved error \(error)");
            }
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)");
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath) as! LaundryMachineCell;
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

}


