//
//  DormStatus+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 11/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


extension DormStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DormStatus> {
        return NSFetchRequest<DormStatus>(entityName: "DormStatus");
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var networked: String?
    @NSManaged public var machines: NSOrderedSet?

}

// MARK: Generated accessors for machines
extension DormStatus {

    @objc(insertObject:inMachinesAtIndex:)
    @NSManaged public func insertIntoMachines(_ value: DormMachines, at idx: Int)

    @objc(removeObjectFromMachinesAtIndex:)
    @NSManaged public func removeFromMachines(at idx: Int)

    @objc(insertMachines:atIndexes:)
    @NSManaged public func insertIntoMachines(_ values: [DormMachines], at indexes: NSIndexSet)

    @objc(removeMachinesAtIndexes:)
    @NSManaged public func removeFromMachines(at indexes: NSIndexSet)

    @objc(replaceObjectInMachinesAtIndex:withObject:)
    @NSManaged public func replaceMachines(at idx: Int, with value: DormMachines)

    @objc(replaceMachinesAtIndexes:withMachines:)
    @NSManaged public func replaceMachines(at indexes: NSIndexSet, with values: [DormMachines])

    @objc(addMachinesObject:)
    @NSManaged public func addToMachines(_ value: DormMachines)

    @objc(removeMachinesObject:)
    @NSManaged public func removeFromMachines(_ value: DormMachines)

    @objc(addMachines:)
    @NSManaged public func addToMachines(_ values: NSOrderedSet)

    @objc(removeMachines:)
    @NSManaged public func removeFromMachines(_ values: NSOrderedSet)

}
