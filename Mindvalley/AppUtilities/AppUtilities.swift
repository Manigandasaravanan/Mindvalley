//
//  AppUtilities.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 03/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class AppUtilities: NSObject {
    
    @objc static let shared = AppUtilities()
    
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
    
    func getDynamicSizeofCell(text: String, prevheight: CGFloat, imageheight: CGFloat) -> CGSize {
        let size = CGSize(width: 172, height: 1000)
        var previousHeight = prevheight
        let attributes = [kCTFontAttributeName: UIFont.init(name: "Gilroy-Bold", size: 17)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        let height = estimatedFrame.height + imageheight
        if height > previousHeight {
            previousHeight = height
        }
        return CGSize(width: 172, height: previousHeight)
    }
    
    func setAttributedString(text: String, lineSpacing: CGFloat, kern: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.kern, value:kern, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
}
