//
//  ChannelsSeriesCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class ChannelsSeriesCell: UICollectionViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overlayImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.posterImg.layer.shadowRadius = 3
//        self.posterImg.layer.shadowColor = UIColor.black.cgColor
//        self.posterImg.layer.shadowOffset = CGSize(width: 0, height: 1)
//        self.posterImg.layer.shadowOpacity = 1.0
        
//        let shadows = UIView()
//        shadows.frame = self.posterImg.frame
//        shadows.clipsToBounds = false
//        self.addSubview(shadows)
//
//        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
//        let layer0 = CALayer()
//        layer0.shadowPath = shadowPath0.cgPath
//        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
//        layer0.shadowOpacity = 1
//        layer0.shadowRadius = 16
//        layer0.shadowOffset = CGSize(width: 0, height: 0)
//        layer0.bounds = shadows.bounds
//        layer0.position = shadows.center
//        shadows.layer.addSublayer(layer0)
//        self.sendSubviewToBack(shadows)
        
//        let shadowSize : CGFloat = 15.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                                   y: -shadowSize / 2,
//                                                   width: self.posterImg.frame.size.width + shadowSize,
//                                                   height: self.posterImg.frame.size.height + shadowSize))
//        self.posterImg.layer.masksToBounds = true
//        self.posterImg.layer.shadowColor = UIColor.black.cgColor
//        self.posterImg.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        self.posterImg.layer.shadowOpacity = 0.5
//        self.posterImg.layer.shadowPath = shadowPath.cgPath
            
        self.posterImg.layer.cornerRadius = 6.5
        self.overlayImage.layer.cornerRadius = 6.5
    }

}
