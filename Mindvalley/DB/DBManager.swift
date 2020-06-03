//
//  DBManager.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit
import MagicalRecord

class DBManager: NSObject {
    
    var rootSavingContext:NSManagedObjectContext?
    var defaultContext:NSManagedObjectContext?
    
    override init()
    {
        super.init()
        setUpCoreData()
    }
    
    // MARK: - Setup Core Data
    func setUpCoreData()
    {
        let filePathInBundle: String = Bundle.main.path(forResource: "Mindvalley", ofType: "sqlite")!
        let filePathBundleURL: URL = URL.init(fileURLWithPath: filePathInBundle)
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsPathURL: URL = URL.init(fileURLWithPath: documentsPath).appendingPathComponent("Mindvalley.sqlite")
        let fileManager = FileManager.default

        print( NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        if fileManager.fileExists(atPath: (documentsPathURL.path))
        {
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
            let currentAppVersion = (appVersion ?? "1" ) + (build ?? "0")
            if let appVersion = UserDefaults.standard.value(forKey: "appVersion") as? String
            {
                if currentAppVersion != appVersion
                {
                    do
                    {
                        try fileManager.removeItem(atPath: documentsPathURL.path)
                    } catch _ as NSError {
                        print("File does not exist")
                    }
                    do
                    {
                        try fileManager.copyItem(at: filePathBundleURL, to: documentsPathURL)
                    } catch let error as NSError
                    {
                        print("Couldn't copy file to final location! Error:" + (error.localizedDescription))
                    }
                }
            }
        }
        else
        {
            do
            {
                try fileManager.copyItem(at: filePathBundleURL, to: documentsPathURL)
            } catch let error as NSError
            {
                print("Couldn't copy file to final location! Error:" + (error.localizedDescription))
            }
        }
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: documentsPathURL)

        rootSavingContext = NSManagedObjectContext.mr_default()
        defaultContext = NSManagedObjectContext.mr_default()
        
    }
    
    // MARK: - Save New Episodes
    func saveNewEpisodesToTable(jsonArray: [Any], onCompletion completionBlock: @escaping BoolBlock) {
        self.truncateNewEpisode()
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        for (index, obj) in jsonArray.enumerated() {
            if let htmlObject: NSDictionary = obj as? NSDictionary {
                
                let lookup: NewEpisodes? = NewEpisodes.mr_createEntity(in: local)
                
                if let data = htmlObject.value(forKey: "type") {
                    lookup?.type = (data as AnyObject).description!
                } else {
                    lookup?.type = ""
                }
                
                if let data = htmlObject.value(forKey: "channel") {
                    if let channel = (data as AnyObject) as? NSDictionary {
                        lookup?.channelTitle = channel.value(forKey: "title") as? String
                    }
                } else {
                    lookup?.channelTitle = ""
                }
                
                if let data = htmlObject.value(forKey: "title") {
                    lookup?.title = (data as AnyObject).description!
                } else {
                    lookup?.title = ""
                }
                
                if let data = htmlObject.value(forKey: "coverAsset") {
                    if let coverAsset = (data as AnyObject) as? NSDictionary {
                        lookup?.coverAssetUrl = coverAsset.value(forKey: "url") as? String
                    }
                } else {
                    lookup?.coverAssetUrl = ""
                }
                lookup?.orderId = "\(index)"
            }
        }
        local.mr_saveToPersistentStore { (_, _) in
            completionBlock(true)
        }
    }
    
    // MARK: - Save Channels
    func saveChannelsToTable(jsonArray: [Any], onCompletion completionBlock: @escaping BoolBlock) {
        self.truncateChannels()
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        for (index, obj) in jsonArray.enumerated() {
            if let htmlObject: NSDictionary = obj as? NSDictionary {

                let lookup: Channels? = Channels.mr_createEntity(in: local)

                if let data = htmlObject.value(forKey: "title") {
                    lookup?.title = (data as AnyObject).description!
                } else {
                    lookup?.title = ""
                }

                if let data = htmlObject.value(forKey: "mediaCount") {
                    lookup?.mediaCount = (data as AnyObject).description!
                } else {
                    lookup?.mediaCount = ""
                }

                if let data = htmlObject.value(forKey: "id") {
                    lookup?.id = (data as AnyObject).description!
                } else {
                    lookup?.id = ""
                }

                if let data = htmlObject.value(forKey: "latestMedia") {
                    let latestMediaJson = AppUtilities.shared.jsonToString(json: data as AnyObject)
                    lookup?.latestMedia = latestMediaJson
                } else {
                    lookup?.latestMedia = ""
                }
                
                if let data = htmlObject.value(forKey: "iconAsset") {
                    if let iconAsset = (data as AnyObject) as? NSDictionary {
                        if let thumbnailUrl = iconAsset.value(forKey: "thumbnailUrl") as? String {
                            lookup?.iconAssetUrl = thumbnailUrl
                        } else {
                            if let thumbnailUrl = iconAsset.value(forKey: "url") as? String {
                                lookup?.iconAssetUrl = thumbnailUrl
                            }
                        }
                    }
                } else {
                    lookup?.iconAssetUrl = ""
                }
                
                if let data = htmlObject.value(forKey: "coverAsset") {
                    if let coverAsset = (data as AnyObject) as? NSDictionary {
                        lookup?.coverAssetUrl = coverAsset.value(forKey: "url") as? String
                    }
                } else {
                    lookup?.coverAssetUrl = ""
                }
                
                if let data = htmlObject.value(forKey: "series") {
                    print("Data :: \(data)")
                    if let series = (data as AnyObject) as? NSArray {
                        if series.count == 0 {
                            lookup?.isSeries = "0"
                            lookup?.series = ""
                        } else {
                            lookup?.isSeries = "1"
                            let seriesJson = AppUtilities.shared.jsonToString(json: data as AnyObject)
                            lookup?.series = seriesJson
                        }
                    }
                } else {
                    lookup?.series = ""
                }
                lookup?.orderId = "\(index)"
            }
        }
        local.mr_saveToPersistentStore { (_, _) in
            completionBlock(true)
        }
    }
    
    // MARK: - Save Categories
    func saveCategoriesToTable(jsonArray: [Any], onCompletion completionBlock: @escaping BoolBlock) {
        self.truncateCategories()
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        for (index, obj) in jsonArray.enumerated() {
            if let htmlObject: NSDictionary = obj as? NSDictionary {
                
                let lookup: Categories? = Categories.mr_createEntity(in: local)
                
                if let data = htmlObject.value(forKey: "name") {
                    lookup?.name = (data as AnyObject).description!
                } else {
                    lookup?.name = ""
                }
                
                lookup?.orderId = "\(index)"
            }
        }
        local.mr_saveToPersistentStore { (_, _) in
            completionBlock(true)
        }
    }
    
    // MARK: - Fetch New Episodes
    func getFieldsForNewEpisodes() -> [NewEpisodes]? {
        let request: NSFetchRequest? = NewEpisodes.mr_requestAll()
        let sortDescriptor = NSSortDescriptor(key: "orderId", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortDescriptors = [sortDescriptor]
        request?.sortDescriptors = sortDescriptors
        let objects = NewEpisodes.mr_executeFetchRequest(request!) as? [NewEpisodes]
        return objects
    }
    
    // MARK: - Fetch Channels
    func getFieldsForChannels() -> [Channels]? {
        let request: NSFetchRequest? = Channels.mr_requestAll()
        let sortDescriptor = NSSortDescriptor(key: "orderId", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortDescriptors = [sortDescriptor]
        request?.sortDescriptors = sortDescriptors
        let objects = Channels.mr_executeFetchRequest(request!) as? [Channels]
        return objects
    }
    
    // MARK: - Fetch Channels
    func getFieldsForCategories() -> [Categories]? {
        let request: NSFetchRequest? = Categories.mr_requestAll()
        let sortDescriptor = NSSortDescriptor(key: "orderId", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        let sortDescriptors = [sortDescriptor]
        request?.sortDescriptors = sortDescriptors
        let objects = Categories.mr_executeFetchRequest(request!) as? [Categories]
        return objects
    }
}

extension DBManager {
    
    // Truncate Tables
    func truncateNewEpisode() {
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        NewEpisodes.mr_truncateAll(in: local)
        local.mr_saveToPersistentStoreAndWait()
    }
    
    func truncateChannels() {
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        Channels.mr_truncateAll(in: local)
        local.mr_saveToPersistentStoreAndWait()
    }
    
    func truncateCategories() {
        let local: NSManagedObjectContext = NSManagedObjectContext.mr_rootSaving()
        Categories.mr_truncateAll(in: local)
        local.mr_saveToPersistentStoreAndWait()
    }
    
}
