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
    @IBOutlet weak var cellHeightConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCells()
//        if let flowLayout = collView?.collectionViewLayout as? UICollectionViewFlowLayout {
//           flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewEpisodesCollectionCell", for: indexPath) as! NewEpisodesCollectionCell
        let episode = self.episodesArr[indexPath.row]
        DispatchQueue.main.async {
            cell.posterImg.sd_setImage(with: URL(string: episode.coverAssetUrl ?? ""), completed: { (image, error, nil, url) in
            })
        }
        cell.titleLabel.text = episode.title
        cell.subtitleLabel.text = episode.channelTitle?.uppercased()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 172, height: 374)
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
