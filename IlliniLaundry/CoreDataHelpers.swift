//
//  CoreDataHelpers.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 07/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//
import Foundation
import CoreData
import SwiftyJSON

class CoreDataHelpers {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let privateContext = appDelegate.privateContext
    
    class func updateAll(json : JSON, completion: ()->() ) {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        
        let dormStatuses = json["location"]["rooms"]

        
        for dormStatus in dormStatuses {
            let id = dormStatus.1["id"].int16Value
            let name = dormStatus.1["name"].stringValue
            let networked = dormStatus.1["networked"].stringValue
            let machines = dormStatus.1["machines"]
            var tempMachines:[DormMachines] = []
            if machines.arrayValue != [] {
                for machine in machines {
                    let port = machine.1["port"].int16Value
                    let label = machine.1["label"].int16Value
                    let description = machine.1["description"].stringValue
                    let status = machine.1["status"].stringValue
                    let startTime = dateFormatter.date(from: machine.1["startTime"].stringValue) ?? Date()
                    let timeRemaining = machine.1["timeRemaining"].stringValue
                    let uniqueID = name + " " + port.description
                    let dormMachine = self.createDormMachine(port: port, label: label, description: description, status: status, startTime: startTime, timeRemaining: timeRemaining, uniqueID: uniqueID, dormName: name)
                    tempMachines.append(dormMachine)
                }
            }
            _ = self.createDormStatus(id: id, name: name, networked: networked, machines: tempMachines)
        }
        completion()
    }
    
    class func createDormMachine(port: Int16, label: Int16, description: String, status: String, startTime: Date, timeRemaining: String, uniqueID: String, dormName: String) -> DormMachines {
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.predicate = NSPredicate(format: "uniqueID == %@", uniqueID)

//        
        if let dormMachines = try? privateContext.fetch(fetchRequest) {
            if dormMachines.count > 0 {
                dormMachines[0].setValue(timeRemaining, forKey: "timeRemaining")
                dormMachines[0].setValue(startTime, forKey: "startTime")
//                dormMachines[0].update(startTime: startTime, timeRemaining: timeRemaining)
//                print(timeRemaining)
                return dormMachines[0];
            }
        }
        
        let machine = NSEntityDescription.insertNewObject(forEntityName: "DormMachines", into: privateContext) as! DormMachines
        machine.initialize(port: port, label: label, description: description, status: status, startTime: startTime, timeRemaining: timeRemaining, uniqueID: uniqueID, dormName: dormName)
        do {
            try privateContext.save()
        } catch let error as NSError {
            print("error saving dorm machine: \(error)")
        }
        return machine
        
    }
    
    class func createDormStatus(id: Int16, name: String, networked: String, machines: [DormMachines]) -> DormStatus{
        let fetchRequest = NSFetchRequest<DormStatus>(entityName: "DormStatus")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        if let dormStatuses = try? privateContext.fetch(fetchRequest) {
            if dormStatuses.count > 0 {
                dormStatuses[0].setValue(NSSet(array: machines), forKey: "dormMachines")
//                dormStatuses[0].update(machines: machines)
                return dormStatuses[0];
            }
        }
        
        let status = NSEntityDescription.insertNewObject(forEntityName: "DormStatus", into: privateContext) as! DormStatus
        status.initialize(id: id, name: name, networked: networked, machines: machines)
        do {
            try privateContext.save()
        } catch let error as NSError {
            print("error saving dorm status: \(error)")
        }
        return status
        
    }
}
