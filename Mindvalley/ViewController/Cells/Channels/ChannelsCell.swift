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
    
    var highestHeight: CGFloat = 0.0
    @IBOutlet weak var collHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var coverTitleLeadingConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.channelsImage.layer.cornerRadius = self.channelsImage.frame.height/2
        self.registerCells()
    }
    
    func registerCells() {
        self.collView.register(UINib(nibName: "NewEpisodesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "NewEpisodesCollectionCell")
    }
    
    func setHeighestheight(height: CGFloat) {
        highestHeight = height
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
        return getCourseCells(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let channelsMedia = self.courseMediaArr[indexPath.row]
        if let title: String = channelsMedia.value(forKey: "title") as? String {
            let dynamicSize = AppUtilities.shared.getDynamicSizeofCell(text: title, prevheight: highestHeight, imageheight: 330)
            self.highestHeight = dynamicSize.height
            DispatchQueue.main.async {
                self.collHeightConstant.constant = self.highestHeight
                self.layoutIfNeeded()
            }
            return dynamicSize
        }
        return CGSize(width: 152, height: self.highestHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
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
    func getCourseCells(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewEpisodesCollectionCell", for: indexPath) as! NewEpisodesCollectionCell
        let channelsMedia = self.courseMediaArr[indexPath.row]
        DispatchQueue.main.async {
            if let coverAsset: NSDictionary = channelsMedia.value(forKey: "coverAsset") as? NSDictionary {
                if let coverUrl: String = coverAsset.value(forKey: "url") as? String {
                    cell.posterImg.sd_imageTransition = .fade
                    cell.posterImg.sd_setImage(with: URL(string: coverUrl), completed: { (image, error, nil, url) in
                    })
                }
            }
        }
        if let title: String = channelsMedia.value(forKey: "title") as? String {
            cell.titleLabel.attributedText = AppUtilities.shared.setAttributedString(text: title, lineSpacing: 6, kern: 0.4)
        }
        return cell
    }
    
}
