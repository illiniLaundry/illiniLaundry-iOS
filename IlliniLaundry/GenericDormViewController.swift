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
    var dateFormatter = DateFormatter();
    
    let kTableHeaderHeight: CGFloat = 300.0;
    let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica", size: 15)];
    
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
        
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .long
        
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
        
        loadSavedData();
        
        DispatchQueue.global(qos: .background).async { [weak self]
            () -> Void in
            CoreDataHelpers.fetchLaundryStatus();
            DispatchQueue.main.async {
                () -> Void in
                self?.loadSavedData();
                print ("THIS IS WHERE WE PRINt");
                print (self?.dorms[0].dormMachines.value(forKey:"timeRemaining"))
                let dorm = self!.dorms[1];
                let dormMachinesArray = Array(dorm.dormMachines);
                for dormMachine in dormMachinesArray {
//                    print ((dormMachine as! DormMachines))
                }
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
        if(dorms.count > 1) {
            return dorms[3].dormMachines.count
        }
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath) as! LaundryMachineCell;
        if(dorms.count > 1) {
            let dorm = dorms[3];
            print (dorm.name);
            cell.DormNameLabel.text = (dorm.dormMachines[indexPath.row] as! DormMachines).timeRemaining;
        }
        

        return cell;
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
    
    func refresh(sender: AnyObject) {
        self.loadSavedData();
    }
    
    func loadSavedData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
        
        let request = DormStatus.createFetchRequest();
        let sort = NSSortDescriptor(key: "name", ascending: true);
        request.sortDescriptors = [sort];
        
        do {
            dorms = try container.viewContext.fetch(request);
            
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.string(
                from: now as Date)
            self.refreshControl?.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
            self.tableView.reloadData();
            print("table reloaded");
            
        } catch {
            let updateString = "Fetch failed"
            self.refreshControl?.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
            print("Fetch failed");
        }
        self.refreshControl?.endRefreshing();
    }
    
    
    

}


