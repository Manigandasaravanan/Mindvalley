//
//  NewEpisodes+CoreDataProperties.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//
//

import Foundation
import CoreData

extension NewEpisodes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewEpisodes> {
        return NSFetchRequest<NewEpisodes>(entityName: "NewEpisodes")
    }

    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var coverAssetUrl: String?
    @NSManaged public var channelTitle: String?
    @NSManaged public var orderId: String?

}
