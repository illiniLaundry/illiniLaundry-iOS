//
//  DormStatus+CoreDataClass.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 22/08/2018.
//  Copyright © 2018 Minhyuk Park. All rights reserved.
//
//

import Foundation
import CoreData


public class DormStatus: NSManagedObject {
    func update(machines: [DormMachines]) {
        self.setValue(NSSet(array: machines), forKey: "dorm_machines")
    }
    
    func initialize(laundry_room_name: String, machines: [DormMachines]) {
        self.laundry_room_name = laundry_room_name
        self.dorm_machines = NSSet(array: machines)
    }
}
