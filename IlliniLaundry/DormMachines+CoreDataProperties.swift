//
//  DormMachines+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 22/08/2018.
//  Copyright © 2018 Minhyuk Park. All rights reserved.
//
//

import Foundation
import CoreData


extension DormMachines {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DormMachines> {
        return NSFetchRequest<DormMachines>(entityName: "DormMachines")
    }

    @NSManaged public var label: Int16
    @NSManaged public var out_of_service: Int16
    @NSManaged public var status: String
    @NSManaged public var appliance_type: String
    @NSManaged public var lrm_status: String
    @NSManaged public var appliance_desc_key: Int32
    @NSManaged public var avg_cycle_time: Int32
    @NSManaged public var time_remaining: String
    @NSManaged public var unique_id: String
    @NSManaged public var dorm_status: DormStatus

}
