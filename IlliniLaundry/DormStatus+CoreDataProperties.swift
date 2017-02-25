//
//  DormStatus+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 24/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


extension DormStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DormStatus> {
        return NSFetchRequest<DormStatus>(entityName: "DormStatus");
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var networked: String
    @NSManaged public var dormMachines: NSSet

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
