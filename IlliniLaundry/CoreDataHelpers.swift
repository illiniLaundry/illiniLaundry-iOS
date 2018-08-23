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
import SWXMLHash

class CoreDataHelpers {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let privateContext = appDelegate.privateContext
    
    class func updateAll(xml : XMLIndexer, completion: ()->() ) {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss"
        print(xml)
        /*
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
        */
    }
    /*
    class func updateSingleDorm(dormName: String, json: JSON, completion: ()->() ) {
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-mm--dd hh:mm:ss"
        
        let index = self.find(dormName)
        
        let dormStatuses = Array(json["location"]["rooms"])[index]
        
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
    */
    
    class func createDormMachine(unique_id: String, time_remaining: String, status: String, out_of_service: Int16, lrm_status: String, label: Int16, avg_cycle_time: Int32, appliance_type: String, appliance_desc_key: Int32) -> DormMachines {
        let fetchRequest = NSFetchRequest<DormMachines>(entityName: "DormMachines")
        fetchRequest.predicate = NSPredicate(format: "unique_id == %@", unique_id)

        // TODO: check if setValue is different from update
        if let dormMachines = try? privateContext.fetch(fetchRequest) {
            if dormMachines.count > 0 {
                dormMachines[0].setValue(time_remaining, forKey: "time_remaining")
                // dormMachines[0].setValue(startTime, forKey: "startTime")
//                dormMachines[0].update(startTime: startTime, timeRemaining: timeRemaining)
//                print(timeRemaining)
                return dormMachines[0];
            }
        }
        
        let machine = NSEntityDescription.insertNewObject(forEntityName: "DormMachines", into: privateContext) as! DormMachines
        machine.initialize(label: label, out_of_service: out_of_service, status: status, appliance_type: appliance_type, lrm_status: lrm_status, appliance_desc_key: appliance_desc_key, avg_cycle_time: avg_cycle_time, time_remaining: time_remaining, unique_id: unique_id)
        do {
            try privateContext.save()
        } catch let error as NSError {
            print("error saving dorm machine: \(error)")
        }
        return machine
        
    }
    
    class func createDormStatus(laundry_room_name: String, machines: [DormMachines]) -> DormStatus{
        let fetchRequest = NSFetchRequest<DormStatus>(entityName: "DormStatus")
        fetchRequest.predicate = NSPredicate(format: "laundry_room_name == %@", laundry_room_name)
        // TODO: check if setValue is different from update
        if let dormStatuses = try? privateContext.fetch(fetchRequest) {
            if dormStatuses.count > 0 {
                dormStatuses[0].setValue(NSSet(array: machines), forKey: "dorm_machines")
//                dormStatuses[0].update(machines: machines)
                return dormStatuses[0];
            }
        }
        
        let status = NSEntityDescription.insertNewObject(forEntityName: "DormStatus", into: privateContext) as! DormStatus
        status.initialize(laundry_room_name: laundry_room_name, machines: machines)
        do {
            try privateContext.save()
        } catch let error as NSError {
            print("error saving dorm status: \(error)")
        }
        return status
        
    }
}
