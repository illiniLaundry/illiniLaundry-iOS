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
import Alamofire
import EventKit

class _GenericDormViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    var mTimer = Timer()
    var dateFormatter = DateFormatter()
    static var dormName = ""
    
    let kTableHeaderHeight: CGFloat = 300.0
    let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica", size: 15)]
    
    var previousScrollOffset: CGFloat = 0
    var headerView: UIView!
    var hideStatusBar: Bool = false
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var dormImageView: UIImageView!
    @IBOutlet weak var dormNameLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dormNameLabel.text = GenericDormViewController.dormName
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.white;
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl!, at: 0)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        

        headerView = tableView.tableHeaderView;
        tableView.tableHeaderView = nil;
        
        tableView.addSubview(headerView);
        tableView.sendSubview(toBack: headerView);
        
        tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight);
        
        let favoritesData = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
        if favoritesData.contains(GenericDormViewController.dormName) {
            let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action:#selector(GenericDormViewController.removeFromFavorites))
            self.navigationItem.rightBarButtonItem = b
        } else {
            let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:#selector(GenericDormViewController.addToFavorites))
            self.navigationItem.rightBarButtonItem = b
        }
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets.zero
        updateHeaderView();
        fetch()
    }
    
    func refresh() {
        APIManager.shared.getAllStatus(success: APIManager.shared.getAllStatusSuccess, failure: APIManager.shared.getAllStatusError)
        self.fetch()
    }
    
    func printData() {
        print(fetchedResultsController.fetchedObjects?.description ?? "EMPTY")
    }
    
    
    func addToFavorites() {
        var favoritesData = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
        if(!favoritesData.contains(GenericDormViewController.dormName)) {
            favoritesData.append(GenericDormViewController.dormName)
            UserDefaults.standard.set(favoritesData, forKey: "favorites")
            print ("added to favorites")
        }
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action:#selector(GenericDormViewController.removeFromFavorites))
        self.navigationItem.rightBarButtonItem = b
 
    }
    
    func removeFromFavorites() {
        var favoritesData = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
        if let index = favoritesData.index(of: GenericDormViewController.dormName) {
            favoritesData.remove(at: index)
            
            UserDefaults.standard.set(favoritesData, forKey: "favorites")
            
            print ("removed from favorites")
        }
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:#selector(GenericDormViewController.addToFavorites))
        self.navigationItem.rightBarButtonItem = b
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                let transition: CATransition = CATransition()
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromLeft
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
                
            case UISwipeGestureRecognizerDirection.left:
                let transition: CATransition = CATransition()
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromRight
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
            default:
                break
            }
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
    
    func setReminder(timeRemaining: String) {
        
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error?.localizedDescription ?? "")
                    } else {
                        print("Access granted")
                    }
            })
        }
        
        if (appDelegate.eventStore != nil) {
            self.createReminder(timeRemaining: timeRemaining)
        }
    }
    
    func createReminder(timeRemaining: String) {
        
        let minutes = Double(String(timeRemaining.characters.filter { "0"..."9" ~= $0 }))
        
        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
        
        reminder.title = "IlliniLaundry"
        reminder.calendar =
            (appDelegate.eventStore?.defaultCalendarForNewReminders())!
        var date = Date()
        date = date.addingTimeInterval(minutes! * 60.0)
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        do {
            try appDelegate.eventStore?.save(reminder,
                                             commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setReminder(timeRemaining: fetchedResultsController.object(at: indexPath).timeRemaining)
    }

    
//    lazy var dormsPrivateMoc: NSManagedObjectContext = {
//        var dormsPrivateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        dormsPrivateMoc.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
//        dormsPrivateMoc.mergePolicy = NSOverwriteMergePolicy
//        return dormsPrivateMoc
//    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<DormMachines> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "port", ascending: true)]
//        fetchRequest.includesSubentities = false
        
        fetchRequest.predicate = NSPredicate(format: "dormName == %@", dormName )
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        }
        catch let error as NSError {
            print("error performing fetch: \(error)")
        }
        return frc
    }()
    
    func fetch() {
//        printData()
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        self.perform(#selector(endRefresh), with: nil, afterDelay: 1)
//        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        OperationQueue.main.addOperation { () -> Void in
            self.tableView.beginUpdates()
//        }
    }
    
    func endRefresh() {
        self.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(indexPath.row < 1) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: IndexPath(row: 0, section: 0))
//            return cell
//        }
        let offsetIndexPath = IndexPath(row: indexPath.row, section: indexPath.section);
        let machine = fetchedResultsController.object(at: offsetIndexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath)
        
        if let cell = cell as? LaundryMachineCell {
            cell.configure(dorm: machine)
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath, let cell = tableView.cellForRow(at: updateIndexPath) else { return }
//            if(updateIndexPath.row <= 0) {
//                return
//            }
//            let offsetIndexPath = IndexPath(row: updateIndexPath.row - 1, section: updateIndexPath.section);
            let dormMachine = fetchedResultsController.object(at: updateIndexPath)
            
            if let cell = cell as? LaundryMachineCell {
                cell.timeRemainingLabel.text = dormMachine.timeRemaining
            }
            
            tableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [toIndexPath],   with: .fade)
            tableView.deleteRows(at: [fromIndexPath], with: .fade)
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections([sectionIndex], with: .fade)
            case .delete:
                tableView.deleteSections([sectionIndex], with: .fade)
            case .update:
                tableView.reloadSections([sectionIndex], with: .fade)
            case .move:
                break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        OperationQueue.main.addOperation { () -> Void in
        self.refreshControl?.endRefreshing()
        self.tableView.endUpdates()
//        }
    }
}
