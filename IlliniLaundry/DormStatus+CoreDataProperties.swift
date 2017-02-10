//
//  DormStatus+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 08/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


extension DormStatus {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<DormStatus> {
        return NSFetchRequest<DormStatus>(entityName: "DormStatus");
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var networked: String
    @NSManaged public var dormMachines: NSMutableOrderedSet
}

// MARK: Generated accessors for dormMachines
extension DormStatus {

    @objc(insertObject:inDormMachinesAtIndex:)
    @NSManaged public func insertIntoDormMachines(_ value: DormMachines, at idx: Int)

    @objc(removeObjectFromDormMachinesAtIndex:)
    @NSManaged public func removeFromDormMachines(at idx: Int)

    @objc(insertDormMachines:atIndexes:)
    @NSManaged public func insertIntoDormMachines(_ values: [DormMachines], at indexes: NSIndexSet)

    @objc(removeDormMachinesAtIndexes:)
    @NSManaged public func removeFromDormMachines(at indexes: NSIndexSet)

    @objc(replaceObjectInDormMachinesAtIndex:withObject:)
    @NSManaged public func replaceDormMachines(at idx: Int, with value: DormMachines)

    @objc(replaceDormMachinesAtIndexes:withDormMachines:)
    @NSManaged public func replaceDormMachines(at indexes: NSIndexSet, with values: [DormMachines])

    @objc(addDormMachinesObject:)
    @NSManaged public func addToDormMachines(_ value: DormMachines)

    @objc(removeDormMachinesObject:)
    @NSManaged public func removeFromDormMachines(_ value: DormMachines)

    @objc(addDormMachines:)
    @NSManaged public func addToDormMachines(_ values: NSOrderedSet)

    @objc(removeDormMachines:)
    @NSManaged public func removeFromDormMachines(_ values: NSOrderedSet)

}
