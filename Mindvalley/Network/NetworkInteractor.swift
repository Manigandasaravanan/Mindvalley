//
//  NetworkInteractor.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 01/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit
import SwiftyJSON

class NetworkInteractor: NSObject {

    var networkLayer: NetworkManager?
    
    override init() {
        networkLayer = NetworkManager()
    }
    
    // Get New Episodes API
    func getNewEpisodes(onCompletion completionBlock: @escaping ObjectJSONBlock, failedMessage: @escaping StringBlock, onerror errorblock: @escaping ErrorBlock) {
        let actualUrl = AppURL.BaseURL + API.getNewEpisodeAPI
        networkLayer?.makeGetCallWithSwiftyJson(params: nil, toURL: actualUrl, successBlock: { (responseObject) in
            completionBlock(responseObject)
        }, failedWithMessage: { (message) in
            failedMessage(message)
        }, errorBlock: { (error) in
            errorblock(error)
        })
    }
    
    // Get Channels API
    func getChannels(onCompletion completionBlock: @escaping ObjectJSONBlock, failedMessage: @escaping StringBlock, onerror errorblock: @escaping ErrorBlock) {
        let actualUrl = AppURL.BaseURL + API.getChannelsAPI
        networkLayer?.makeGetCallWithSwiftyJson(params: nil, toURL: actualUrl, successBlock: { (responseObject) in
            completionBlock(responseObject)
        }, failedWithMessage: { (message) in
            failedMessage(message)
        }, errorBlock: { (error) in
            errorblock(error)
        })
    }
    
    // Get Categories API
    func getCategories(onCompletion completionBlock: @escaping ObjectJSONBlock, failedMessage: @escaping StringBlock, onerror errorblock: @escaping ErrorBlock) {
        let actualUrl = AppURL.BaseURL + API.getCategoriesAPI
        networkLayer?.makeGetCallWithSwiftyJson(params: nil, toURL: actualUrl, successBlock: { (responseObject) in
            completionBlock(responseObject)
        }, failedWithMessage: { (message) in
            failedMessage(message)
        }, errorBlock: { (error) in
            errorblock(error)
        })
    }
    
}
