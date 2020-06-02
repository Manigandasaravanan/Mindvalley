//
//  AppConstants.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 01/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import Foundation
import UIKit

var safeAreaTop: CGFloat? {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets.top
    } else {
        return 0.0
    }
}

struct AppMessages {
    static let noInternet = "No Internet"
    static let noServer = "Server not responding"
    
}
