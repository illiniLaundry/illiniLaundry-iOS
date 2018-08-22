//
//  DormStatus+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 22/08/2018.
//  Copyright © 2018 Minhyuk Park. All rights reserved.
//
//

import Foundation
import CoreData


extension DormStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DormStatus> {
        return NSFetchRequest<DormStatus>(entityName: "DormStatus")
    }

    @NSManaged public var laundry_room_name: String
    @NSManaged public var dorm_machines: NSSet

}

// MARK: Generated accessors for dormMachines
extension DormStatus {

    @objc(addDormMachinesObject:)
    @NSManaged public func addToDormMachines(_ value: DormMachines)

    @objc(removeDormMachinesObject:)
    @NSManaged public func removeFromDormMachines(_ value: DormMachines)

    @objc(addDormMachines:)
    @NSManaged public func addToDormMachines(_ values: NSSet)

    @objc(removeDormMachines:)
    @NSManaged public func removeFromDormMachines(_ values: NSSet)

}
