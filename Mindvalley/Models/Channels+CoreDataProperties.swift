//
//  Channels+CoreDataProperties.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//
//

import Foundation
import CoreData

extension Channels {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Channels> {
        return NSFetchRequest<Channels>(entityName: "Channels")
    }

    @NSManaged public var title: String?
    @NSManaged public var series: String?
    @NSManaged public var mediaCount: String?
    @NSManaged public var latestMedia: String?
    @NSManaged public var id: String?
    @NSManaged public var iconAssetUrl: String?
    @NSManaged public var coverAssetUrl: String?
    @NSManaged public var isSeries: String?

}
