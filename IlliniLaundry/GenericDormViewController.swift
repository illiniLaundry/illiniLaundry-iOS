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

class GenericDormViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    var mTimer = Timer()
    var dateFormatter = DateFormatter()
    lazy var dormName = ""
    
    let kTableHeaderHeight: CGFloat = 300.0
    let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica", size: 15)]
    
    var previousScrollOffset: CGFloat = 0
    var headerView: UIView!
    var hideStatusBar: Bool = false
    

    
    
    @IBOutlet weak var dormImageView: UIImageView!
    @IBOutlet weak var dormNameLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        updateHeaderView();
        mTimer = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(printData), userInfo: nil, repeats: true)
    }
    
    func refresh() {
        APIManager.shared.getAllStatus(success: APIManager.shared.getAllStatusSuccess, failure: APIManager.shared.getAllStatusError)
        fetch()
    }
    
    func printData() {
        print(fetchedResultsController.fetchedObjects?.description ?? "EMPTY")
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
                print("Swiped right")
                let transition: CATransition = CATransition()
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromLeft
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "showEventDetails", sender: indexPath)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<DormMachines> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "port", ascending: true)]
        fetchRequest.includesSubentities = false
        
//        fetchRequest.predicate = NSPredicate(format: "dormName == %@", "LAR: Leonard")
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func fetch() {
        print("called fetch")
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("will change content")
        tableView.beginUpdates()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: IndexPath(row: 1, section: 0))
            return cell
        }
        let offsetIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section);
        let machine = fetchedResultsController.object(at: offsetIndexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath)
        
        if let cell = cell as? LaundryMachineCell {
            print(machine.dormName)
            cell.timeRemainingLabel.text = machine.timeRemaining
        }
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("did change an object")
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath, let cell = tableView.cellForRow(at: updateIndexPath) else { return }
            if(updateIndexPath.row <= 0) {
                return
            }
            let offsetIndexPath = IndexPath(row: updateIndexPath.row - 1, section: updateIndexPath.section);
            let dormMachine = fetchedResultsController.object(at: offsetIndexPath)
            
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
        print("didchange sectionInfo")
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
        print("did change content")
        tableView.endUpdates()
    }
    
    
    
    

}

