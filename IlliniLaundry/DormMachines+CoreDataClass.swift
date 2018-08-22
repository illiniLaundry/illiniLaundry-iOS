//
//  DormMachines+CoreDataClass.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 22/08/2018.
//  Copyright © 2018 Minhyuk Park. All rights reserved.
//
//

import Foundation
import CoreData


public class DormMachines: NSManagedObject {
    func update(time_remaining: String) {
        self.setValue(time_remaining, forKey: "time_remaining")
    }
    
    func initialize(label: Int16, out_of_service: Int16, status: String, appliance_type: String, lrm_status: String, appliance_desc_key: Int32, avg_cycle_time: Int32, time_remaining: String, unique_id: String) {
        self.label = label
        self.out_of_service = out_of_service
        self.status = status
        self.appliance_type = appliance_type
        self.lrm_status = lrm_status
        self.appliance_desc_key = appliance_desc_key
        self.avg_cycle_time = avg_cycle_time
        self.time_remaining = time_remaining
        self.unique_id = self.dorm_status.laundry_room_name + String(self.appliance_desc_key)
    }
}
