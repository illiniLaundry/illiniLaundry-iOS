//
//  ManagedSchool+CoreDataProperties.swift
//  IlliniLaundry
//
//  Created by Minhyuk Park on 11/02/2017.
//  Copyright © 2017 Minhyuk Park. All rights reserved.
//

import Foundation
import CoreData


extension ManagedSchool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedSchool> {
        return NSFetchRequest<ManagedSchool>(entityName: "ManagedSchool");
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var company: String?
    @NSManaged public var networked: Bool
    @NSManaged public var school: DormStatus?

}
