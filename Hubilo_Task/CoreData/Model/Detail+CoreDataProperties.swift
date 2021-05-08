//
//  Detail+CoreDataProperties.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//
//

import Foundation
import CoreData


extension Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail> {
        return NSFetchRequest<Detail>(entityName: "Detail")
    }

    @NSManaged public var height: Int64
    @NSManaged public var width: Int64
    @NSManaged public var url: String?
    @NSManaged public var downloadURL: String?
    @NSManaged public var author: String?
    @NSManaged public var id: String?
    @NSManaged public var imgData: Data?

}

extension Detail : Identifiable {

}
