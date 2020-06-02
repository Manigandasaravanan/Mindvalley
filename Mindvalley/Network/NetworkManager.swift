//
//  NetworkManager.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 01/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ObjectJSONBlock = (_ responseObject: JSON?) -> Void
typealias ObjectBlock = (_ responseObject: NSDictionary?) -> Void
typealias StringBlock = (_ responseObject: String?) -> Void
typealias ErrorBlock = (_ error: NSError?) -> Void
typealias BoolBlock = (_ responseObject: Bool) -> Void

class NetworkManager: NSObject {
    
    var managerArray: NSMutableArray?
    
    override init() {
        super.init()
        managerArray = NSMutableArray()
    }
    
    func getSessionManager() -> Alamofire.Session {
        var shuntingManager: Alamofire.Session
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        shuntingManager = Session(configuration: configuration, serverTrustManager: nil)
        return shuntingManager
    }
    
    func makeGetCallWithSwiftyJson(params: [String: Any]?, toURL: String, successBlock: @escaping ObjectJSONBlock, failedWithMessage: @escaping StringBlock, errorBlock: @escaping ErrorBlock) {
        DispatchQueue.main.async {
            if !APPPresenter.shared.isInternetConnectionAvailable() {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: AppMessages.noInternet])
                errorBlock(error)
            }
        }
        let manager: Alamofire.Session? = getSessionManager()
        managerArray?.add(manager!)
        manager?.session.configuration.timeoutIntervalForRequest = 60
        
        manager?.request(toURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let code = json["responseCode"].string {
                    if code == "1" {
                        successBlock(json)
                    } else {
                        let stringForError: String = AppMessages.noServer
                        failedWithMessage(stringForError)
                        return
                    }
                } else {
                    successBlock(json)
                    return
                }
            case .failure(let error):
                errorBlock(error as NSError)
            }
        }
        
    }

}
