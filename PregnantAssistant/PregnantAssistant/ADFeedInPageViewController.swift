//
//  ADFeedInPageViewController.swift
//  
//
//  Created by D on 15/7/7.
//
//

import UIKit

class ADFeedInPageViewController: ADBaseContentListVC {

    var noFeedView: ADEmptyView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList", name: updateFeedListNotification, object: nil)

        let grayColor = NSDictionary(object: UIColor.emptyViewTextColor(), forKey: NSForegroundColorAttributeName)
        let greenColor = NSDictionary(object: UIColor.emptyGreenColor(), forKey: NSForegroundColorAttributeName)
        
        var attributeString = NSMutableAttributedString(string: "这里空空的，快去订阅吧")
        attributeString.setAttributes(greenColor as [NSObject : AnyObject], range: NSRange(location: 6, length: 5))
        attributeString.setAttributes(grayColor as [NSObject : AnyObject], range: NSRange(location: 0, length: 6))

        noFeedView = ADEmptyView(frame: CGRectMake(0, 0, screenWidth, screenHeight), attributeString: attributeString, imageName: UIImage(named: "list_loading_06"), textClicked: { () -> Void in
                self.navigationController?.pushViewController(ADFeedRecommendViewController(), animated: true)
        })
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        self.addRefreshAndInfi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateList() {
        self.refreshData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.event(contentList_load_7)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.myTableView.scrollsToTop = false
    }
    
    override func loadData() {
        noFeedView.removeFromSuperview()

        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleDot2Notification, object: nil)
//        myTableView.backgroundView = ADLoadingView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
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
                
                if self.tableViewData.count == 0 {
                    self.view .addSubview(self.noFeedView)
                } else {
                    self.noFeedView .removeFromSuperview()
                    let aInfo :ADMomContentInfo = resArray[0]
                    self.currentContentId = aInfo.contentId
                }
            }
        }
    }
    
//    override func finishLoadData() {
//        let time: NSTimeInterval = 1
//        let delay = dispatch_time(DISPATCH_TIME_NOW,
//            Int64(time * Double(NSEC_PER_SEC)))
//        dispatch_after(delay, dispatch_get_main_queue()) {
//            self.loading = false
//        }
//    }
//    
    override func refreshData() {
        currentIdx = 0
        noFeedView.removeFromSuperview()
        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleDot2Notification, object: nil)
        MomLookNetworkHelper.getContentList(channelId, contentId: "", start: currentIdx, size: reqLength) { (res, err) -> Void in
            if let resArray = res as? [ADMomContentInfo] {
                self.tableViewData.removeAll(keepCapacity: false)
                self.tableViewData += resArray
//                println("tableData: \(self.tableViewData)")
                self.myTableView.reloadData()
                self.currentIdx = self.tableViewData.count
                if resArray.count > 0 {
                    self.noFeedView.removeFromSuperview()
                    let aInfo :ADMomContentInfo = resArray[0]
                    self.currentContentId = aInfo.contentId
                } else {
                    //self.myTableView.backgroundView = self.noFeedView
                    self.view.addSubview(self.noFeedView)
                }
            }
            self.finishLoadData()
                println("offset :\(self.myTableView.contentOffset)")
//            while (self.myTableView.contentOffset.y > 0) {
//
//                println("offset :\(self.myTableView.contentOffset)")
//            }
            println("end")
            self.refreshControl.endRefreshing()
            self.myTableView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
    }
    
    override func loadMore() {
        noFeedView.removeFromSuperview()

        MomLookNetworkHelper.getContentList(channelId, contentId: currentContentId, start: currentIdx, size: reqLength) { (res, err) -> Void in
            if let resArray = res as? [ADMomContentInfo] {
                if resArray.count > 0 {
                    self.myTableView.backgroundView = nil
                    self.tableViewData += resArray
                    self.myTableView.reloadData()
                    self.currentIdx = self.tableViewData.count
                }
            }
            self.myTableView.infiniteScrollingView.stopAnimating()
        }
    }
}
