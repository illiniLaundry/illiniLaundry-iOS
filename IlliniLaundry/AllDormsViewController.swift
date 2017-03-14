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

class AllDormsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, IndicatorInfoProvider {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        collectionView.delegate = self
        collectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        let w = collectionView!.bounds.width
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = w - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        layout.itemSize = CGSize(width:widthPerItem,height:widthPerItem * 1.2)
        layout.minimumInteritemSpacing = sectionInsets.left
        layout.minimumLineSpacing = sectionInsets.left
        
        collectionView!.collectionViewLayout = layout
        
        self.collectionView!.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(AllDormsViewController.refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
        
        
        fetch()

    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "All Dorms")
    }
    
    func refresh() {
        APIManager.shared.getAllStatus(success: APIManager.shared.getAllStatusSuccess, failure: APIManager.shared.getAllStatusError)
        self.fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<DormStatus> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<DormStatus>(entityName: "DormStatus")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.includesSubentities = false
        
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        }
        catch let error as NSError {
            print("error performing fetch: \(error.localizedDescription)")
        }
        
        return frc
    }()
    
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to preform fetch operation, error: \(error)")
        }
        
//        self.collectionView.reloadData()
        
        self.perform(#selector(endRefresh), with: nil, afterDelay: 1)
    }
    
    func endRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dormCell", for: indexPath) as! DormCell
        cell.configure(dorm: fetchedResultsController.object(at: indexPath))
        cell.dormLabel.allowsDefaultTighteningForTruncation = true
        let path = UIBezierPath(roundedRect:cell.dormLabel.layer.bounds,
                                byRoundingCorners:[.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 3, height:  3))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cell.dormLabel.layer.mask = maskLayer
        cell.layoutIfNeeded()
        return cell
    }
    
    var blockOperations: [BlockOperation] = []
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.insert {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItems(at: [newIndexPath!])
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.update {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItems(at: [indexPath!])
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.move {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItems(at: [indexPath!])
                    }
                })
            )
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        
        if type == NSFetchedResultsChangeType.insert {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.update {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.refreshControl.endRefreshing()
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepingCapacity: false)
    }
    
}
