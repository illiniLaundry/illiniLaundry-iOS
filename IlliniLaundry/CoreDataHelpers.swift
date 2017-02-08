//
//  CoreDataHelpers.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 07/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import CoreData
import SwiftyJSON

class CoreDataHelpers {

    
    class func fetchLaundryStatus() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
        var completed = false;
        if let data = try? Data(contentsOf: URL(string: "http://23.23.147.128/homes/mydata/urba7723")!) {
            let jsonUIUC = JSON(data: data)
            let dormJSONArray = jsonUIUC["location"]["rooms"].arrayValue;
            
            DispatchQueue.main.async {
                for dormJSON in dormJSONArray{
                    let dormStatus = DormStatus(context: container.viewContext);
                    
                    self.configure(dormStatus: dormStatus, usingJSON: dormJSON);
                    print("pulled dormJSON");
                }
                completed = true;
                print("debug statement in fetch laundry status");
                self.saveContext();
            }
        }
    }
    class func configure(dormStatus: DormStatus,
                   usingJSON dormJson: JSON){
        //        dormStatus.id = dormJson["id"].int16Value;
        dormStatus.name = dormJson["name"].stringValue;
        //        dormStatus.networked = dormJson["networked"].stringValue;
        //        dormStatus.dormMachines = configure(usingJSON: dormJson["machines"]);
        print(dormStatus);
        print("configured dorm status");
    }
    class func configure(usingJSON dormMachinesJson: JSON) -> NSMutableOrderedSet{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
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
    class func clear() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
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
    class func saveContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.container!;
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)");
            }
        }
    }
    
}
