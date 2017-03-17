//
//  Item+CoreDataClass.swift
//  DreamLister2
//
//  Created by Ping Li on 2016-12-16.
//  Copyright © 2016 Ping Li. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
        
    }
}
