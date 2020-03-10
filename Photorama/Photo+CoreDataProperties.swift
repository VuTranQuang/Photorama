//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by VuTQ10 on 3/9/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSObject?
    @NSManaged public var title: String?

}
