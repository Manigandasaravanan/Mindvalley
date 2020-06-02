//
//  ChannelsCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class ChannelsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var channelsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noOfEpisodesLabel: UILabel!
    
    @IBOutlet weak var collView: UICollectionView!
    var courseMediaArr = [NSDictionary]()
    var seriesMediaArr = [NSDictionary]()
    @IBOutlet weak var thumbImgWidthConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.channelsImage.layer.cornerRadius = self.channelsImage.frame.height/2
        self.registerCells()
    }
    
    func registerCells() {
        self.collView.register(UINib(nibName: "NewEpisodesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "NewEpisodesCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChannelsCell {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseMediaArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewEpisodesCollectionCell", for: indexPath) as! NewEpisodesCollectionCell
        let channelsMedia = self.courseMediaArr[indexPath.row]
        DispatchQueue.main.async {
            if let coverAsset: NSDictionary = channelsMedia.value(forKey: "coverAsset") as? NSDictionary {
                if let coverUrl: String = coverAsset.value(forKey: "url") as? String {
                    cell.posterImg.sd_setImage(with: URL(string: coverUrl), completed: { (image, error, nil, url) in
                    })
                }
            }
        }
        if let title: String = channelsMedia.value(forKey: "title") as? String {
            cell.titleLabel.text = title
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 152, height: 374)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
