//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Mina Guirguis on 10/27/17.
//  Copyright © 2017 Mina Guirguis. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
