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
    var container: NSPersistentContainer!;
    var fetchedResultsController: NSFetchedResultsController<DormStatus>!;
    var dorms = [DormStatus]();
    
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
        
        clear();
        loadSavedData();
        
        
    }
    
    func fetchLaundryStatus() {
        if let data = try? Data(contentsOf: URL(string: "http://23.23.147.128/homes/mydata/urba7723")!) {
            let jsonUIUC = JSON(data: data)
            let dormJSONArray = jsonUIUC["location"]["rooms"].arrayValue;
            
            
            DispatchQueue.main.async { [unowned self] in
                for dormJSON in dormJSONArray{
                    let dormStatus = DormStatus(context: self.container.viewContext);
                  
                    self.configure(dormStatus: dormStatus, usingJSON: dormJSON);
                    print("pulled dormJSON");
                }
                print("debug statement in fetch laundry status");
                self.saveContext();
                self.loadSavedData();
            }
        }
    }
    func configure(dormStatus: DormStatus,
                   usingJSON dormJson: JSON){
        dormStatus.id = dormJson["id"].int16Value;
        dormStatus.name = dormJson["name"].stringValue;
        dormStatus.networked = dormJson["networked"].stringValue;
        dormStatus.dormMachines = configure(usingJSON: dormJson["machines"]);
        print(dormStatus);
        print("configured dorm status");
    }
    
    func configure(usingJSON dormMachinesJson: JSON) -> NSMutableOrderedSet{
        let dormMachinesMutableSet = NSMutableOrderedSet();
        
        let max = dormMachinesJson.arrayValue.count;
        
        
        let managedContext = container.viewContext;

        for _ in 1...max {
            let dormMachines = NSEntityDescription.insertNewObject(forEntityName: "DormMachines", into: managedContext) as? DormMachines;
            dormMachines?.port = dormMachinesJson["port"].int16Value;
            dormMachines?.label = dormMachinesJson["label"].int16Value;
            dormMachines?.description_ = dormMachinesJson["description"].stringValue;
            dormMachines?.status = dormMachinesJson["status"].stringValue;
            
            let formatter = ISO8601DateFormatter();
            dormMachines?.startTime = formatter.date(from: dormMachinesJson["startTime"].stringValue) ?? Date();
            
            dormMachines?.timeRemaining = dormMachinesJson["timeRemaining"].int16Value;
            dormMachinesMutableSet.add(dormMachines!);
            print("add dormMachine");
        }
        print("configured dorm status");
        return dormMachinesMutableSet;
        
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
        if(fetchedResultsController == nil) {
            return 1;
        }
        return (fetchedResultsController.fetchedObjects?.count)!;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath) as! LaundryMachineCell;
        
        let dorm = fetchedResultsController.object(at: indexPath)
        cell.DormNameLabel.text = dorm.name;
        return cell;
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            
        default:
            break
        }
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
        let managedContext = container.viewContext;
        
        if fetchedResultsController == nil {
            let request = DormStatus.createFetchRequest();
            let sort = NSSortDescriptor(key: "name", ascending: true);
            request.sortDescriptors = [sort];
            request.fetchBatchSize = 20;
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil);
            fetchedResultsController.delegate = self;
        }
        
        do {
            try fetchedResultsController.performFetch();
            tableView.reloadData();
            print("table reloaded");
        } catch {
            print("Fetch failed");
        }
    }
    
    func clear() {
        let context = container.viewContext
        
        for i in 0...container.managedObjectModel.entities.count-1 {
            let entity = container.managedObjectModel.entities[i]
            
            do {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
                try context.execute(deleterequest)
                try context.save()
                
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }

}


