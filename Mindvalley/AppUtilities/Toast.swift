//
//  Toast.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class Toast {
    class private func showAlert(backgroundColor: UIColor, textColor: UIColor, message: String) {
        let height: CGFloat = safeAreaTop!
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont.init(name: "Gilroy-Bold", size: 17)
        label.adjustsFontSizeToFitWidth = true
        
        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR
        
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        
        label.clipsToBounds = true
        let initialFrame: CGRect = CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width - 32, height: height)
        label.frame = initialFrame
        label.alpha = 1
        
        UIApplication.shared.keyWindow?.addSubview(label)
        
        var basketTopFrame: CGRect = initialFrame
        basketTopFrame.origin.y = safeAreaTop! + 20
        UIView.animate(withDuration: 0.5, animations: {
            label.frame = basketTopFrame
            label.layer.cornerRadius = label.frame.size.height/2
        }, completion: { (_) in
            
            UIView.animate(withDuration: 1, delay: 3, options: .curveEaseOut, animations: {
                label.frame = initialFrame
            }, completion: { (_) in
                label.removeFromSuperview()
            })
        })
    }
    
    class func showPositiveMessage(message: String) {
        showAlert(backgroundColor: UIColor.init(hex: "C1C1C1"), textColor: UIColor.black, message: message)
    }
    class func showNegativeMessage(message: String) {
        showAlert(backgroundColor: UIColor.red, textColor: UIColor.white, message: message)
    }
}
