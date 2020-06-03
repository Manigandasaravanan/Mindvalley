//
//  NewEpisodesCell.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 02/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit
import SDWebImage

class NewEpisodesCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collView: UICollectionView!
    var episodesArr = [NewEpisodes]()
    @IBOutlet weak var newEpisodeTitleLabel: UILabel!
    @IBOutlet weak var collHeightConstant: NSLayoutConstraint!
    
    var highestHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCells()
    }
    
    func registerCells() {
        self.collView.register(UINib(nibName: "NewEpisodesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "NewEpisodesCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewEpisodesCell {
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodesArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getNewEpisodesCells(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let episode = self.episodesArr[indexPath.row]
        if let title = episode.title {
            let dynamicSize = AppUtilities.shared.getDynamicSizeofCell(text: title, prevheight: highestHeight, imageheight: 330)
            self.highestHeight = dynamicSize.height
            DispatchQueue.main.async {
                self.collHeightConstant.constant = self.highestHeight
                self.layoutIfNeeded()
            }
            return dynamicSize
        }
        return CGSize(width: 172, height: 374)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
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
    func getNewEpisodesCells(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewEpisodesCollectionCell", for: indexPath) as! NewEpisodesCollectionCell
        let episode = self.episodesArr[indexPath.row]
        DispatchQueue.main.async {
            cell.posterImg.sd_imageTransition = .fade
            cell.posterImg.sd_setImage(with: URL(string: episode.coverAssetUrl ?? ""), completed: { (image, error, nil, url) in
            })
        }
        cell.titleLabel.attributedText = AppUtilities.shared.setAttributedString(text: episode.title ?? "", lineSpacing: 5, kern: 0.4)
        cell.subtitleLabel.attributedText = AppUtilities.shared.setAttributedString(text: episode.channelTitle?.uppercased() ?? "", lineSpacing: 4, kern: 1)
        return cell
    }
    
}
