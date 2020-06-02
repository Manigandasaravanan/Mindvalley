//
//  CategoriesCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class CategoriesCell: UICollectionViewCell {

//    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = self.frame.height/2
    }

}
