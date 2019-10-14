//
//  CharacterEntity+CoreDataClass.swift
//  
//
//  Created by Yinhuan Yuan on 5/22/19.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }
    
    @NSManaged public var name: String?

}
