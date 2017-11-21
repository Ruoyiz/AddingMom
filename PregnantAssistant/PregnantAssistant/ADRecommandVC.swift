//
//  ViewController.swift
//  cacheCellHeightDemo
//
//  Created by D on 15/6/23.
//  Copyright (c) 2015年 D. All rights reserved.
//

import UIKit

class ADRecommandVC: ADBaseContentListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList", name: updateRecommadListNotification, object: nil)
//        cellId = "recCell"
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.addRefreshAndInfi()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.myTableView.scrollsToTop = true
        MobClick.endEvent(contentList_load_1)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.myTableView.scrollsToTop = false
    }

    func updateList() {
        self.refreshData()
    }

    override func loadData() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleDot1Notification, object: nil)
        MomLookNetworkHelper.getContentList(channelId, contentId: "", start: currentIdx, size: reqLength) { (res, err) -> Void in
            if err != nil {
                self.myTableView.backgroundView =
                    ADFailLodingView(frame: CGRectMake(0, 0, screenWidth, screenHeight), tapBlock: { () -> Void in
                        self.loadData()
                    })
            } else if let resArray = res as? [ADMomContentInfo] {
                self.tableViewData += resArray

                self.myTableView.reloadData()

                self.currentIdx = self.tableViewData.count
                self.myTableView.backgroundView = nil
                
                let aInfo :ADMomContentInfo = resArray[0]
                self.currentContentId = aInfo.contentId
            }
        } 
    }
    
    
    
    override func refreshData() {
        currentIdx = 0
        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleDot1Notification, object: nil)
        MomLookNetworkHelper.getContentList(channelId, contentId: "", start: currentIdx, size: reqLength)
            { (res, err) -> Void in
                if let resArray = res as? [ADMomContentInfo] {
                    self.tableViewData.removeAll(keepCapacity: false)
                    self.tableViewData += resArray
                    self.myTableView.reloadData()
                    self.currentIdx = self.tableViewData.count
                    
                    let aInfo :ADMomContentInfo = resArray[0]
                    self.currentContentId = aInfo.contentId
                }
                self.refreshControl.endRefreshing()
                
                self.finishLoadData()
                self.myTableView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
    }
    
    override func loadMore() {
        MomLookNetworkHelper.getContentList(channelId, contentId: currentContentId, start: currentIdx, size: reqLength) { (res, err) -> Void in
            if let resArray = res as? [ADMomContentInfo] {
                if resArray.count > 0 {
                    self.tableViewData += resArray
                    self.myTableView.reloadData()
                    self.currentIdx = self.tableViewData.count
                }
            }
            self.myTableView.infiniteScrollingView.stopAnimating()
        }
    }
}