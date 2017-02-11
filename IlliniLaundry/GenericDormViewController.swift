//
//  GenericDormViewController.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 2/6/17.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import UIKit
import DATAStack
import CoreData
import Sync
import SwiftyJSON
import Alamofire

class GenericDormViewController: UITableViewController {
    var dateFormatter = DateFormatter();
    
    let kTableHeaderHeight: CGFloat = 300.0;
    let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica", size: 15)];
    
    var previousScrollOffset: CGFloat = 0;
    var headerView: UIView!;
    var hideStatusBar: Bool = false;
    
    unowned var dataStack: DATAStack
    var dormMachines = [NSManagedObject]()
    
    @IBOutlet weak var dormImageView: UIImageView!;
    @IBOutlet weak var dormNameLabel: UILabel!;
    
    required init(dataStack: DATAStack) {
        self.dataStack = dataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init!(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        
//        self.dateFormatter.dateStyle = .short
//        self.dateFormatter.timeStyle = .long
//        
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl?.tintColor = UIColor.white;
//        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
//        self.tableView.insertSubview(refreshControl!, at: 0)
//        
//        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        self.view.addGestureRecognizer(swipeRight)
//        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
//        self.view.addGestureRecognizer(swipeLeft)
//        
//
//        headerView = tableView.tableHeaderView;
//        tableView.tableHeaderView = nil;
//        
//        tableView.addSubview(headerView);
//        tableView.sendSubview(toBack: headerView);
//        
//        tableView.contentInset = UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0);
//        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight);
//        updateHeaderView();
        self.fetchNewData();
        self.fetchCurrentObjects();
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateHeaderView()
//    }
    
    
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
        self.fetchNewData();
        self.fetchCurrentObjects();

    }
    
    func fetchNewData() {
        let source = "http://23.23.147.128/homes/mydata/urba7723";
        
        Alamofire.request(source).responseJSON { response in
            let data = response.result.value as! [String : Any]
            Sync.changes(data["location"] as! [[String : Any]], inEntityNamed: "ManagedSchool", dataStack: self.dataStack) { error in
            }
        }
    }
    
    func fetchCurrentObjects() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DormStatus")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.predicate = NSPredicate(format: "name == %@", "Allen");
        self.dormMachines = (try! dataStack.mainContext.fetch(request)) as! [NSManagedObject]
        self.tableView.reloadData()
    }
    
    
    

}

extension GenericDormViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->       Int {
        return self.dormMachines.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaundryMachineCell", for: indexPath) as! LaundryMachineCell;
        let oneMachine = self.dormMachines[indexPath.row]
        cell.textLabel?.text = oneMachine.value(forKey: "timeRemaining") as? String
        return cell;
    }
}

