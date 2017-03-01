//
//  AllDormsViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData

class AllDormsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, IndicatorInfoProvider {



    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var allDormsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.tintColor = UIColor.white;
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.allDormsTableView.insertSubview(refreshControl, at: 0)
        allDormsTableView.delegate = self
        allDormsTableView.dataSource = self
        fetch()

    }
    
    func refresh() {
        APIManager.shared.getAllStatus(success: APIManager.shared.getAllStatusSuccess, failure: APIManager.shared.getAllStatusError)
        self.fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "All Dorms")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        allDormsTableView.deselectRow(at: indexPath, animated: true)
        //        performSegue(withIdentifier: "showEventDetails", sender: indexPath)
    }
    
    //    lazy var dormsPrivateMoc: NSManagedObjectContext = {
    //        var dormsPrivateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        dormsPrivateMoc.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
    //        dormsPrivateMoc.mergePolicy = NSOverwriteMergePolicy
    //        return dormsPrivateMoc
    //    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<DormStatus> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<DormStatus>(entityName: "DormStatus")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
//        fetchRequest.includesSubentities = false
        
        
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
        print("called fetch")
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        refreshControl.endRefreshing()
        allDormsTableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        OperationQueue.main.addOperation { () -> Void in
        self.allDormsTableView.beginUpdates()
        //        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row < 1) {
            let cell = allDormsTableView.dequeueReusableCell(withIdentifier: "loadingCell", for: IndexPath(row: 0, section:0))
            return cell
        }
        if(indexPath.row * 3 <= (fetchedResultsController.fetchedObjects?.count)! ) {
            let cell = allDormsTableView.dequeueReusableCell(withIdentifier: "threeDormCell", for: indexPath) as! ThreeDormCell
            let firstOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let thirdOffset = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            cell.configure(first: fetchedResultsController.object(at: firstOffset), second: fetchedResultsController.object(at: indexPath), third: fetchedResultsController.object(at:thirdOffset))
                return cell
        } else if((fetchedResultsController.fetchedObjects?.count)! % 3 == 1) {
            let cell = allDormsTableView.dequeueReusableCell(withIdentifier: "twoDormCell", for: indexPath) as! TwoDormCell
            let firstOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            cell.configure(first: fetchedResultsController.object(at: firstOffset), second: fetchedResultsController.object(at: indexPath))
            return cell
        } else {
            let cell = allDormsTableView.dequeueReusableCell(withIdentifier: "oneDormCell", for: indexPath) as! OneDormCell
            let firstOffset = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            cell.configure(first: fetchedResultsController.object(at: firstOffset))
            return cell
        }

    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            allDormsTableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            allDormsTableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath, let cell = allDormsTableView.cellForRow(at: updateIndexPath) else { return }
            if(updateIndexPath.row <= 0) {
                return
            }
            
            if((indexPath?.row)! * 3 <= (fetchedResultsController.fetchedObjects?.count)! ) {
                let cell = cell as! ThreeDormCell
                let firstOffset = IndexPath(row: (indexPath?.row)! - 1, section: (indexPath?.section)!)
                let thirdOffset = IndexPath(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                cell.configure(first: fetchedResultsController.object(at: firstOffset), second: fetchedResultsController.object(at: indexPath!), third: fetchedResultsController.object(at:thirdOffset))
            } else if((fetchedResultsController.fetchedObjects?.count)! % 3 == 1) {
                let cell = cell as! TwoDormCell
                let firstOffset = IndexPath(row: (indexPath?.row)! - 1, section: (indexPath?.section)!)
                cell.configure(first: fetchedResultsController.object(at: firstOffset), second: fetchedResultsController.object(at: indexPath!))
            } else {
                let cell = cell as! OneDormCell
                let firstOffset = IndexPath(row: (indexPath?.row)! - 1, section: (indexPath?.section)!)
                cell.configure(first: fetchedResultsController.object(at: firstOffset))
            }
            allDormsTableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            allDormsTableView.insertRows(at: [toIndexPath],   with: .fade)
            allDormsTableView.deleteRows(at: [fromIndexPath], with: .fade)
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            allDormsTableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            allDormsTableView.deleteSections([sectionIndex], with: .fade)
        case .update:
            allDormsTableView.reloadSections([sectionIndex], with: .fade)
        case .move:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        OperationQueue.main.addOperation { () -> Void in
        self.allDormsTableView.endUpdates()
        //        }
    }

    
    
    
    
}
