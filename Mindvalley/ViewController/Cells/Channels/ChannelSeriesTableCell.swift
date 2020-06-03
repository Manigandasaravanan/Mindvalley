//
//  ChannelSeriesTableCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class ChannelSeriesTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var channelsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noOfEpisodesLabel: UILabel!
    
    @IBOutlet weak var collView: UICollectionView!
    var seriesMediaArr = [NSDictionary]()
    @IBOutlet weak var thumbImgWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var coverTitleLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var collHeightConstant: NSLayoutConstraint!
    var highestHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.channelsImage.layer.cornerRadius = self.channelsImage.frame.height/2
        registerCells()
    }
    
    func registerCells() {
         self.collView.register(UINib(nibName: "ChannelsSeriesCell", bundle: nil), forCellWithReuseIdentifier: "ChannelsSeriesCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChannelSeriesTableCell {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesMediaArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getSeriesCells(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 356, height: 248)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Get tableview cells
    func getSeriesCells(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelsSeriesCell", for: indexPath) as! ChannelsSeriesCell
        let seriesMedia = self.seriesMediaArr[indexPath.row]
        DispatchQueue.main.async {
            if let coverAsset: NSDictionary = seriesMedia.value(forKey: "coverAsset") as? NSDictionary {
                if let coverUrl: String = coverAsset.value(forKey: "url") as? String {
                    cell.posterImg.sd_imageTransition = .fade
                    cell.posterImg.sd_setImage(with: URL(string: coverUrl), completed: { (image, error, nil, url) in
                    })
                }
            }
        }
        if let title: String = seriesMedia.value(forKey: "title") as? String {
            cell.titleLabel.attributedText = AppUtilities.shared.setAttributedString(text: title, lineSpacing: 5, kern: 0.4)
        }
        return cell
    }
    
}

