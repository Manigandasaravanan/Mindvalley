//
//  APPPresenter.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 01/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class APPPresenter: NSObject {
    
    @objc static let shared = APPPresenter()
    var networkInteractor: NetworkInteractor?
    var dbManager: DBManager?
    var newEpisodes: [NewEpisodes]?
    var channels: [Channels]?
    var categories: [Categories]?
    
    required override init() {
        super.init()
        initialiseMainClasses()
    }
    
    // Initialise all the main classes in this method.
    func initialiseMainClasses() {
        networkInteractor = NetworkInteractor()
        dbManager = DBManager()
    }
    
    // New Episodes Webservice call
    func getNewEpisodes(onCompletion completionBlock: @escaping BoolBlock) {
        self.networkInteractor?.getNewEpisodes(onCompletion: { (responseObject) in
            if let media = responseObject?["data"]["media"].arrayObject {
                self.dbManager?.saveNewEpisodesToTable(jsonArray: media, onCompletion: { (status) in
                    if status {
                        self.newEpisodes = self.dbManager?.getFieldsForNewEpisodes()
                        completionBlock(true)
                    }
                })
            }
        }, failedMessage: { (failedMessage) in
            if let failedMsg = failedMessage {
                self.showToast(message: failedMsg)
            }
        }, onerror: { (errorMessage) in
            if errorMessage?.localizedDescription == AppMessages.noInternet {
                // Load from DB
                self.newEpisodes = self.dbManager?.getFieldsForNewEpisodes()
                if self.newEpisodes?.count == 0 {
                    self.showToast(message: AppMessages.noInternet)
                } else {
                    completionBlock(true)
                }
            }
        })
    }

    // Channels Webservice call
    func getChannels(onCompletion completionBlock: @escaping BoolBlock) {
        self.networkInteractor?.getChannels(onCompletion: { (responseObject) in
            if let channels = responseObject?["data"]["channels"].arrayObject {
                self.dbManager?.saveChannelsToTable(jsonArray: channels) { (status) in
                    if status {
                        self.channels = self.dbManager?.getFieldsForChannels()
                        completionBlock(true)
                    }
                }
            }
        }, failedMessage: { (failedMessage) in
            if let failedMsg = failedMessage {
                self.showToast(message: failedMsg)
            }
        }, onerror: { (errorMessage) in
            if errorMessage?.localizedDescription == AppMessages.noInternet {
                // Load from DB
                self.channels = self.dbManager?.getFieldsForChannels()
                if self.channels?.count == 0 {
                    self.showToast(message: AppMessages.noInternet)
                } else {
                    completionBlock(true)
                }
            }
        })
    }
    
    // Categories Webservice call
    func getCategories(onCompletion completionBlock: @escaping BoolBlock) {
        self.networkInteractor?.getCategories(onCompletion: { (responseObject) in
            if let categories = responseObject?["data"]["categories"].arrayObject {
                self.dbManager?.saveCategoriesToTable(jsonArray: categories, onCompletion: { (status) in
                    if status {
                        self.categories = self.dbManager?.getFieldsForCategories()
                        completionBlock(true)
                    }
                })
            }
        }, failedMessage: { (failedMessage) in
            if let failedMsg = failedMessage {
                self.showToast(message: failedMsg)
            }
        }, onerror: { (errorMessage) in
            if errorMessage?.localizedDescription == AppMessages.noInternet {
                // Load from DB
                self.categories = self.dbManager?.getFieldsForCategories()
                if self.channels?.count == 0 {
                    self.showToast(message: AppMessages.noInternet)
                } else {
                    completionBlock(true)
                }
            }
        })
    }
    
}

extension APPPresenter {
    
    // Check internet connection is available
    func isInternetConnectionAvailable() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    // Show Toast Messages
    func showToast(message: String) {
        Toast.showPositiveMessage(message: message)
    }
    
    func convertJsonStringToJson(jsonString: String) -> [NSDictionary]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
            debugPrint(convertedString)
            return convertedString as String
        } catch let myJSONError {
            debugPrint(myJSONError)
            return ""
        }
    }
    
}
