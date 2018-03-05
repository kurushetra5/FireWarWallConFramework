//
//  ConectionNode+CoreDataProperties.swift
//  FireWarWall
//
//  Created by Kurushetra on 5/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//
//

import Foundation
import CoreData


extension ConectionNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConectionNode> {
        return NSFetchRequest<ConectionNode>(entityName: "ConectionNode")
    }

    @NSManaged public var adress: String?
    @NSManaged public var destination: String?
    @NSManaged public var ip: String?
    @NSManaged public var source: String?
    @NSManaged public var timesConected: Int16
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var conected: Bool

}
