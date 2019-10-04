//
//  Document+CoreProp.swift
//  DocumentsCoreData
//
//  Created by Megan Wilson on 9/19/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import Foundation
import CoreData

extension Document {
    
    @nonobjc public class func NSfetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var size: Int64
    @NSManaged public var rawModifiedDate: NSDate?
    @NSManaged public var content: String?
    
}
