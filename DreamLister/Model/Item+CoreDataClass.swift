//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Mina Guirguis on 10/27/17.
//  Copyright © 2017 Mina Guirguis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()//when inserted into ObjectContext assign current date to attribute "created"
        
        
        
        
    }//any time this item is inserted into NSMangedObjectContext this function will be called
    
    
}
