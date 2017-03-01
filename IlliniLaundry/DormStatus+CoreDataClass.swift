//
//  DormStatus+CoreDataClass.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 24/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


public class DormStatus: NSManagedObject {
    
    func update(machines: [DormMachines]) {
        self.setValue(NSSet(array: machines), forKey: "dormMachines")
    }
    
    func initialize(id: Int16, name: String, networked: String, machines: [DormMachines]) {
        self.id = id
        self.name = name
        self.networked = networked
        self.dormMachines = NSSet(array: machines)
    }
}
