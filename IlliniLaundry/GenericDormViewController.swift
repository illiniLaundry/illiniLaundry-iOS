//
//  SampleViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 15/03/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import UIKit
import LFTwitterProfile
import CoreData

class GenericDormViewController: TwitterProfileViewController, NSFetchedResultsControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var dormNameStatic = ""
    
    var laundryMachinesTableView: UITableView!
    var dryersTableView: UITableView!
    
    
    var custom: UIView!
    var label: UILabel!
    
    
    lazy var laundryMachinesFetchedResultsController: NSFetchedResultsController<DormMachines> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "port", ascending: true)]
        //        fetchRequest.includesSubentities = false
        let laundryMachinePredicate = NSPredicate(format: "%K CONTAINS %@", "description_", "Washer")
        let dormNamePredicate = NSPredicate(format: "dormName == %@", dormNameStatic )
        
        let andPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [laundryMachinePredicate, dormNamePredicate])
        
        fetchRequest.predicate = andPredicate
        
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
    
    lazy var dryersFetchedResultsController: NSFetchedResultsController<DormMachines> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "port", ascending: true)]
        //        fetchRequest.includesSubentities = false
        
        let dryerPredicate = NSPredicate(format: "%K CONTAINS %@", "description_", "Dryer")
        let dormNamePredicate = NSPredicate(format: "dormName == %@", dormNameStatic )
        
        let andPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [dryerPredicate, dormNamePredicate])
        
        fetchRequest.predicate = andPredicate
        
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
    
    func refresh() {
        APIManager.shared.getAllStatus(success: APIManager.shared.getAllStatusSuccess, failure: APIManager.shared.getAllStatusError)
        self.fetchDryers()
        self.fetchLaundryMachines()
    }
    
    

    
    
    override func numberOfSegments() -> Int {
        return 2
    }
    
    override func segmentTitle(forSegment index: Int) -> String {
        if(index == 0) {
            return "Laundry Machines"
        }
        return "Dryers"
    }
    
    override func prepareForLayout() {
        // TableViews
        let _laundryMachinesTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.laundryMachinesTableView = _laundryMachinesTableView
        
        let _dryersTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.dryersTableView = _dryersTableView
        
        self.setupTables()
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dormName = GenericDormViewController.dormNameStatic
        self.dormImage = UIImage(named: GenericDormViewController.dormNameStatic)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let favoritesData = UserDefaults.standard.stringArray(forKey: "favorites") ?? [String]()
        if(!favoritesData.contains(self.dormName!)) {
            self.favoritesButtonTitle = "Add to Favorites"
        }
        else {
            self.favoritesButtonTitle = "Remove from Favorites"
        }

        
        refresh()
    }
    
    override func scrollView(forSegment index: Int) -> UIScrollView {
        switch index {
        case 0:
            return laundryMachinesTableView
        case 1:
            return dryersTableView
        default:
            return laundryMachinesTableView
        }
    }
    
 }



// MARK: UITableViewDelegates & DataSources
extension GenericDormViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setupTables() {
        self.laundryMachinesTableView.delegate = self
        self.laundryMachinesTableView.dataSource = self
        laundryMachinesTableView.register(UINib(nibName: "LaundryMachineCell", bundle: nil), forCellReuseIdentifier: "laundryMachineCell")
        
        self.dryersTableView.delegate = self
        self.dryersTableView.dataSource = self
        dryersTableView.register(UINib(nibName: "LaundryMachineCell", bundle: nil), forCellReuseIdentifier: "laundryMachineCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.laundryMachinesTableView:
            return laundryMachinesFetchedResultsController.sections?[section].numberOfObjects ?? 0
        case self.dryersTableView:
            return dryersFetchedResultsController.sections?[section].numberOfObjects ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.laundryMachinesTableView:
            let machine = laundryMachinesFetchedResultsController.object(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "laundryMachineCell", for: indexPath) as! LaundryMachineCell
            
            cell.configure(dorm: machine)
            
            cell.layoutIfNeeded()
            return cell
            
        case self.dryersTableView:
            let machine = dryersFetchedResultsController.object(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "laundryMachineCell", for: indexPath)
            
            if let cell = cell as? LaundryMachineCell {
                cell.configure(dorm: machine)
            }
            cell.layoutIfNeeded()
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if(controller == laundryMachinesFetchedResultsController) {
            switch type {
            case .insert:
                guard let insertIndexPath = newIndexPath else { return }
                laundryMachinesTableView.insertRows(at: [insertIndexPath], with: .fade)
            case .delete:
                guard let deleteIndexPath = indexPath else { return }
                laundryMachinesTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            case .update:
                guard let updateIndexPath = indexPath, let cell = laundryMachinesTableView.cellForRow(at: updateIndexPath) else { return }
            //            if(updateIndexPath.row <= 0) {
            //                return
            //            }
            //            let offsetIndexPath = IndexPath(row: updateIndexPath.row - 1, section: updateIndexPath.section);
                let dormMachine = laundryMachinesFetchedResultsController.object(at: updateIndexPath)
            
                if let cell = cell as? LaundryMachineCell {
                    cell.timeRemainingLabel.text = dormMachine.timeRemaining
                }
            
                laundryMachinesTableView.reloadRows(at: [updateIndexPath], with: .fade)
            case .move:
                guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
                laundryMachinesTableView.insertRows(at: [toIndexPath],   with: .fade)
                laundryMachinesTableView.deleteRows(at: [fromIndexPath], with: .fade)
            }
        } else {
            switch type {
            case .insert:
                guard let insertIndexPath = newIndexPath else { return }
                dryersTableView.insertRows(at: [insertIndexPath], with: .fade)
            case .delete:
                guard let deleteIndexPath = indexPath else { return }
                dryersTableView.deleteRows(at: [deleteIndexPath], with: .fade)
            case .update:
                guard let updateIndexPath = indexPath, let cell = dryersTableView.cellForRow(at: updateIndexPath) else { return }
                //            if(updateIndexPath.row <= 0) {
                //                return
                //            }
                //            let offsetIndexPath = IndexPath(row: updateIndexPath.row - 1, section: updateIndexPath.section);
                let dormMachine = dryersFetchedResultsController.object(at: updateIndexPath)
                
                if let cell = cell as? LaundryMachineCell {
                    cell.timeRemainingLabel.text = dormMachine.timeRemaining
                }
                
                dryersTableView.reloadRows(at: [updateIndexPath], with: .fade)
            case .move:
                guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
                dryersTableView.insertRows(at: [toIndexPath],   with: .fade)
                dryersTableView.deleteRows(at: [fromIndexPath], with: .fade)
            }
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if(controller == laundryMachinesFetchedResultsController) {
            switch type {
            case .insert:
                laundryMachinesTableView.insertSections([sectionIndex], with: .fade)
            case .delete:
                laundryMachinesTableView.deleteSections([sectionIndex], with: .fade)
            case .update:
                laundryMachinesTableView.reloadSections([sectionIndex], with: .fade)
            case .move:
                break
            }
        } else {
            switch type {
            case .insert:
                dryersTableView.insertSections([sectionIndex], with: .fade)
            case .delete:
                dryersTableView.deleteSections([sectionIndex], with: .fade)
            case .update:
                dryersTableView.reloadSections([sectionIndex], with: .fade)
            case .move:
                break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        OperationQueue.main.addOperation { () -> Void in
        // self.refreshControl?.endRefreshing()
        switch(controller) {
        case laundryMachinesFetchedResultsController:
            self.laundryMachinesTableView.endUpdates()
            var currentString = "Available Laundry Machines: "
            currentString.append(laundryMachinesTableView.numberOfRows(inSection:0).description)
            self.availableLaundryMachines = currentString
            break
        case dryersFetchedResultsController:
            self.dryersTableView.endUpdates()
            var currentString = "Available Dryers: "
            currentString.append(dryersTableView.numberOfRows(inSection:0).description)
            self.availableDryers = currentString
            break
        default:
            break
        }
        //        }
    }

    
    func fetchLaundryMachines() {
        //        printData()
        do {
            try laundryMachinesFetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        self.perform(#selector(endRefresh), with: nil, afterDelay: 1)
        //        tableView.reloadData()
        var currentString = "Available Laundry Machines: "
        currentString.append(laundryMachinesTableView.numberOfRows(inSection:0).description)
        self.availableLaundryMachines = currentString
        
        
    }
    
    func fetchDryers() {
        //        printData()
        do {
            try dryersFetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        self.perform(#selector(endRefresh), with: nil, afterDelay: 1)
        //        tableView.reloadData()

        var currentString = "Available Dryers: "
        currentString.append(dryersTableView.numberOfRows(inSection:0).description)
        self.availableDryers = currentString
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        switch(controller) {
        case laundryMachinesFetchedResultsController:
            self.laundryMachinesTableView.beginUpdates()
            break
        case dryersFetchedResultsController:
            self.dryersTableView.beginUpdates()
            break
        default:
            break
        }
    }
    
    func endRefresh() {
        print("ENDREFRESH")
    }


}
