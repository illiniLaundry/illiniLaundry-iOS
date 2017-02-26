//
//  DormMachines+CoreDataClass.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 24/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


public class DormMachines: NSManagedObject {
    
    func update(startTime: Date, timeRemaining: String) {
        self.startTime = startTime;
        self.timeRemaining = timeRemaining;
    }
    
    func initialize(port: Int16, label: Int16, description: String, status: String, startTime: Date, timeRemaining: String, uniqueID: String, dormName: String) {
        self.port = port
        self.label = label
        self.description_ = description
        self.status = status
        self.startTime = startTime
        self.timeRemaining = timeRemaining
        self.uniqueID = uniqueID
        self.dormName = dormName
        print("finished initializing dorm machine")
    }
    
    

}
