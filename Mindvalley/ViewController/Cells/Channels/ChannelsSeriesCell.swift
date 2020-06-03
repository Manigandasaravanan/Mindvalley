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
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let shadowPath0 = UIBezierPath(roundedRect: CGRect(x:  shadowView.frame.origin.x, y:  shadowView.frame.origin.y, width:  shadowView.frame.size.width, height: shadowView.frame.size.height), cornerRadius: 6.5)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 6
        layer0.shadowOffset = CGSize(width: 0, height: 0)
        layer0.bounds = CGRect(x:  shadowView.frame.origin.x, y:  shadowView.frame.origin.y, width:  shadowView.frame.size.width, height: shadowView.frame.size.height)
        layer0.position = CGPoint(x: shadowView.center.x - 8, y: shadowView.center.y - 5)
        shadowView.layer.addSublayer(layer0)
        
        self.posterImg.layer.cornerRadius = 6.5
        self.overlayImage.layer.cornerRadius = 6.5
    }

}
