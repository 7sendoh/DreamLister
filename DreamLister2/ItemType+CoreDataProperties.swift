//
//  ItemType+CoreDataProperties.swift
//  DreamLister2
//
//  Created by Ping Li on 2016-12-16.
//  Copyright © 2016 Ping Li. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
