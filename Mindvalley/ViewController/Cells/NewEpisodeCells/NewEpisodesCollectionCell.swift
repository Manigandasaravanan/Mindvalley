//
//  NewEpisodesCollectionCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class NewEpisodesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.posterImg.layer.cornerRadius = 8
        
        
    }

}
