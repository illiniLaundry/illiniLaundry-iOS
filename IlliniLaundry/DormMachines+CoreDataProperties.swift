//
//  DormMachines+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 24/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


extension DormMachines {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DormMachines> {
        return NSFetchRequest<DormMachines>(entityName: "DormMachines");
    }

    @NSManaged public var description_: String
    @NSManaged public var label: Int16
    @NSManaged public var port: Int16
    @NSManaged public var startTime: Date
    @NSManaged public var status: String
    @NSManaged public var timeRemaining: String
    @NSManaged public var uniqueID: String
    @NSManaged public var dormName: String
    @NSManaged public var dormStatus: DormStatus

}
