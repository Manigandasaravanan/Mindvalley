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
    var noOfApiCallsDone = 0
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.checkInternetConnection()
        
        self.setRefreshControl()
        self.triggerApiCalls()
        self.setContentOffset()
    }
    
    func setRefreshControl() {
        let attr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Gilroy-Semibold", size: 14)] as [AnyHashable : NSObject?]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:attr as? [NSAttributedString.Key : Any])
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        homeTable.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        DispatchQueue.main.async {
            if !AppUtilities.shared.isInternetConnectionAvailable() {
                AppUtilities.shared.showToast(message: AppMessages.noInternet)
                self.refreshControl.endRefreshing()
            }
        }
        self.triggerApiCalls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            self.refreshControl.endRefreshing()
        }
    }
    
    func triggerApiCalls() {
        self.getNewEpisodes()
        self.getChannels()
        self.getCategories()
    }
    
    func getNewEpisodes() {
        APPPresenter.shared.getNewEpisodes { (status) in
            self.noOfApiCallsDone += 1
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
            self.noOfApiCallsDone += 1
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
            self.noOfApiCallsDone += 1
            if let categories = APPPresenter.shared.categories {
                if categories.count > 0 {
                    self.noOfRows += 1
                }
            }
            self.isAllApiCallDone()
        }
    }
    
    func isAllApiCallDone() {
        if self.noOfApiCallsDone == 3 {
            DispatchQueue.main.async {
                self.homeTable.reloadData()
            }
        }
    }
    
    func setContentOffset() {
        homeTable.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    
    func checkInternetConnection() {
        DispatchQueue.main.async {
            if !AppUtilities.shared.isInternetConnectionAvailable() {
                AppUtilities.shared.showToast(message: AppMessages.noInternet)
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
            return getChannelCell(tableView: tableView)
        } else if indexPath.row == 1 {
            // New Episode Cells
            return getNewEpisodesCell(tableView: tableView)
        } else if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            // Categories Cells
            return getCategoriesCell(tableView: tableView)
        } else if indexPath.row > 1 {
            // Channels cells
            if let channels = APPPresenter.shared.channels {
                let channel = channels[indexPath.row - 2]
                if channel.isSeries == "0" {
                    return getCoursesCell(tableView: tableView, channel: channel)
                } else {
                    return getSeriesCell(tableView: tableView, channel: channel)
                }
            }
        }
        return getChannelCell(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == (tableView.numberOfRows(inSection: 0) - 1) {
            return UITableView.automaticDimension
        } else if indexPath.row > 1 {
            if let channels = APPPresenter.shared.channels {
                let channel = channels[indexPath.row - 2]
                if channel.isSeries == "1" {
                    return 340
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    // MARK: - Get tableview cells
    func getChannelCell(tableView: UITableView) -> UITableViewCell {
        let cell : ChannelsHeadingCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsHeadingCell") as!  ChannelsHeadingCell
        cell.selectionStyle = .none
        cell.channelHeadingLabel.attributedText = AppUtilities.shared.setAttributedString(text: "Channels", lineSpacing: 1, kern: 0.4)
        return cell
    }
    
    func getNewEpisodesCell(tableView: UITableView) -> UITableViewCell {
        let cell : NewEpisodesCell = tableView.dequeueReusableCell(withIdentifier: "NewEpisodesCell") as!  NewEpisodesCell
        cell.selectionStyle = .none
        if let newEpisodes = APPPresenter.shared.newEpisodes {
            cell.episodesArr = Array(newEpisodes.prefix(6))
        }
        cell.newEpisodeTitleLabel.attributedText = AppUtilities.shared.setAttributedString(text: "New Episodes", lineSpacing: 1, kern: 0.4)
        DispatchQueue.main.async {
            cell.collView.reloadData()
        }
        return cell
    }
    
    func getCategoriesCell(tableView: UITableView) -> UITableViewCell {
        let cell : CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell") as!  CategoriesTableCell
        cell.selectionStyle = .none
        cell.categoriesArr = APPPresenter.shared.categories ?? []
        cell.browseCatLabel.attributedText = AppUtilities.shared.setAttributedString(text: "Browse by categories", lineSpacing: 1, kern: 0.4)
        DispatchQueue.main.async {
            cell.collView.reloadData()
            DispatchQueue.main.async {
                let height = cell.collView.collectionViewLayout.collectionViewContentSize.height
                cell.categoryHeightConstant.constant = height
                self.view.layoutIfNeeded()
            }
        }
        return cell
    }
    
    func getCoursesCell(tableView: UITableView, channel: Channels) -> UITableViewCell {
        let cell : ChannelsCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsCell") as! ChannelsCell
        if let courseMediaArr = AppUtilities.shared.convertJsonStringToJson(jsonString: channel.latestMedia ?? "") {
            cell.courseMediaArr = Array(courseMediaArr.prefix(6))
        }
        cell.selectionStyle = .none
        cell.titleLabel.attributedText = AppUtilities.shared.setAttributedString(text: channel.title ?? "", lineSpacing: 1, kern: 0.14)
        cell.noOfEpisodesLabel.attributedText = AppUtilities.shared.setAttributedString(text: "\(channel.mediaCount ?? "0") episodes", lineSpacing: 1, kern: 0.11)
        DispatchQueue.main.async {
            if channel.iconAssetUrl == "" || channel.iconAssetUrl == nil {
                cell.thumbImgWidthConstant.constant = 0
                cell.coverTitleLeadingConstant.constant = 0
                self.view.layoutIfNeeded()
            } else {
                cell.thumbImgWidthConstant.constant = 50
                cell.coverTitleLeadingConstant.constant = 14
                self.view.layoutIfNeeded()
                cell.channelsImage.sd_imageTransition = .fade
                cell.channelsImage.sd_setImage(with: URL(string: channel.iconAssetUrl ?? ""), completed: { (image, error, nil, url) in
                })
            }
        }
        DispatchQueue.main.async {
            cell.collView.reloadData()
            self.view.layoutIfNeeded()
        }
        return cell
    }
    
    func getSeriesCell(tableView: UITableView, channel: Channels) -> UITableViewCell {
        let cell : ChannelSeriesTableCell = tableView.dequeueReusableCell(withIdentifier: "ChannelSeriesTableCell") as! ChannelSeriesTableCell
        if let seriesArr = AppUtilities.shared.convertJsonStringToJson(jsonString: channel.series ?? "") {
            cell.seriesMediaArr = Array(seriesArr.prefix(6))
        }
        cell.selectionStyle = .none
        cell.titleLabel.attributedText = AppUtilities.shared.setAttributedString(text: channel.title ?? "", lineSpacing: 1, kern: 0.14)
        cell.noOfEpisodesLabel.attributedText = AppUtilities.shared.setAttributedString(text: "\(channel.mediaCount ?? "0") episodes", lineSpacing: 1, kern: 0.11)
        DispatchQueue.main.async {
            if channel.iconAssetUrl == "" || channel.iconAssetUrl == nil {
                cell.thumbImgWidthConstant.constant = 0
                cell.coverTitleLeadingConstant.constant = 0
                self.view.layoutIfNeeded()
            } else {
                cell.thumbImgWidthConstant.constant = 50
                cell.coverTitleLeadingConstant.constant = 14
                self.view.layoutIfNeeded()
                cell.channelsImage.sd_imageTransition = .fade
                cell.channelsImage.sd_setImage(with: URL(string: channel.iconAssetUrl ?? ""), completed: { (image, error, nil, url) in
                })
            }
        }
        DispatchQueue.main.async {
            cell.collView.reloadData()
            self.view.layoutIfNeeded()
        }
        return cell
    }
    
}
