//
//  ViewController.swift
//  Mindvalley
//
//  Created by Maniganda Saravanan on 01/06/2020.
//  Copyright © 2020 Maniganda Saravanan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTable: UITableView!
    var noOfRows = 1
    var noOfApiCalls = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getNewEpisodes()
        self.getChannels()
        self.getCategories()
    }
    
    func getNewEpisodes() {
        APPPresenter.shared.getNewEpisodes { (status) in
            self.noOfApiCalls += 1
            if let newEpisodes = APPPresenter.shared.newEpisodes {
                if newEpisodes.count > 0 {
                    self.noOfRows += 1
                }
            }
            self.isAllApiCallDone()
        }
    }

    func getChannels() {
        APPPresenter.shared.getChannels { (status) in
            self.noOfApiCalls += 1
            if let channels = APPPresenter.shared.channels {
                if channels.count > 0  {
                    self.noOfRows += channels.count
                }
            }
            self.isAllApiCallDone()
        }
    }
    
    func getCategories() {
        APPPresenter.shared.getCategories { (status) in
            self.noOfApiCalls += 1
            if let categories = APPPresenter.shared.categories {
                if categories.count > 0 {
                    self.noOfRows += 1
                }
            }
            self.isAllApiCallDone()
        }
    }
    
    func isAllApiCallDone() {
        if self.noOfApiCalls == 3 {
            DispatchQueue.main.async {
                self.homeTable.reloadData()
            }
        }
    }
}

extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell : ChannelsHeadingCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsHeadingCell") as!  ChannelsHeadingCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            // New Episode Cells
            let cell : NewEpisodesCell = tableView.dequeueReusableCell(withIdentifier: "NewEpisodesCell") as!  NewEpisodesCell
            cell.selectionStyle = .none
            if let newEpisodes = APPPresenter.shared.newEpisodes {
                cell.episodesArr = Array(newEpisodes.prefix(6))
            }
            DispatchQueue.main.async {
                cell.collView.reloadData()
            }
            return cell
        } else if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            // Categories Cells
            let cell : CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell") as!  CategoriesTableCell
            cell.selectionStyle = .none
            cell.categoriesArr = APPPresenter.shared.categories ?? []
            DispatchQueue.main.async {
                cell.collView.reloadData()
                DispatchQueue.main.async {
                    print("CollViewContentSize :: \(cell.collView.contentSize.height)/")
                    let height = cell.collView.collectionViewLayout.collectionViewContentSize.height
                    cell.categoryHeightConstant.constant = height
                    self.view.layoutIfNeeded()
                }
            }
            return cell
        } else if indexPath.row > 1 {
            // Channels cells
            if let channels = APPPresenter.shared.channels {
                let channel = channels[indexPath.row - 2]
                if channel.isSeries == "0" {
                    let cell : ChannelsCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsCell") as! ChannelsCell
                    if let courseMediaArr = APPPresenter.shared.convertJsonStringToJson(jsonString: channel.latestMedia ?? "") {
                        cell.courseMediaArr = Array(courseMediaArr.prefix(6))
                    }
                    cell.selectionStyle = .none
                    cell.titleLabel.text = channel.title
                    cell.noOfEpisodesLabel.text = "\(channel.mediaCount ?? "0") episodes"
                    DispatchQueue.main.async {
                        if channel.iconAssetUrl == "" || channel.iconAssetUrl == nil {
                            cell.thumbImgWidthConstant.constant = 0
                            self.view.layoutIfNeeded()
                        } else {
                            cell.channelsImage.sd_setImage(with: URL(string: channel.iconAssetUrl ?? ""), completed: { (image, error, nil, url) in
                            })
                        }
                    }
                    DispatchQueue.main.async {
                        cell.collView.reloadData()
                    }
                    return cell
                } else {
                    let cell : ChannelSeriesTableCell = tableView.dequeueReusableCell(withIdentifier: "ChannelSeriesTableCell") as! ChannelSeriesTableCell
                    let channel = channels[indexPath.row - 2]
                    if let seriesArr = APPPresenter.shared.convertJsonStringToJson(jsonString: channel.series ?? "") {
                        cell.seriesMediaArr = Array(seriesArr.prefix(6))
                    }
                    cell.selectionStyle = .none
                    cell.titleLabel.text = channel.title
                    cell.noOfEpisodesLabel.text = "\(channel.mediaCount ?? "0") episodes"
                    DispatchQueue.main.async {
                        if channel.iconAssetUrl == "" || channel.iconAssetUrl == nil {
                            cell.thumbImgWidthConstant.constant = 0
                            self.view.layoutIfNeeded()
                        } else {
                            cell.thumbImgWidthConstant.constant = 50
                            self.view.layoutIfNeeded()
                            cell.channelsImage.sd_setImage(with: URL(string: channel.iconAssetUrl ?? ""), completed: { (image, error, nil, url) in
                            })
                        }
                    }
                    DispatchQueue.main.async {
                        cell.collView.reloadData()
                    }
                    return cell
                }
            }
        }
        let cell : ChannelsHeadingCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsHeadingCell") as!  ChannelsHeadingCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 459
        } else if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            return UITableView.automaticDimension
        } else if indexPath.row > 1 {
            if let channels = APPPresenter.shared.channels {
                let channel = channels[indexPath.row - 2]
                if channel.isSeries == "0" {
                    return 440
                } else {
                    return 340
                }
            }
        }
        return UITableView.automaticDimension
    }
    
}
