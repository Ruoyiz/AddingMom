//
//  ADMomLookCollectVC.swift
//  PregnantAssistant
//
//  Created by D on 15/6/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

import UIKit

class ADMomLookCollectVC: UIViewController {

    var channelId = 0
    let loginCellId = "TipLoginCellId"
    let collectCellId = "collectCellId"
    var loading = false
    var loadedData = false
    var targetRect: NSValue!

    //本地 同步过的数据
    var netWorkFav = [ADMomContentInfo]()
    var unNetWorkFav = [ADMomContentInfo]()
    var allFav = [ADMomContentInfo]()
    var findFav = [ADMomContentInfo]()
    
    var currentListInx:UInt = 0
    let reqListLength:UInt = 6
    
    var aTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight - 49))
    let refreshControl = UIRefreshControl(frame: CGRectMake(0, 0, screenWidth, 40))
    //tmp remove
//    var displaySearchBar = ADCollectSearchBar(frame: CGRectMake(0, 0, screenWidth, 40))
    
    let cellHeight:CGFloat = 34 + 80.0
    
//    var mySearchDisplayController: UISearchDisplayController!
    
    var currentIsInSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        aTableView.backgroundView = ADLoadingView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        aTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        aTableView.setContentOffset(CGPointMake(0, -64), animated: false)
        aTableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
//        self.automaticallyAdjustsScrollViewInsets = true
//        self.extendedLayoutIncludesOpaqueBars = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateList", name: updateColloctListNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logOut", name: "logoutNotification", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        MobClick.event(contentList_load_8)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if loadedData == false{
            self.loadData { () -> Void in
            }
        }
        
        loadedData = true
    }
    
    func setupTableView() {
        view.addSubview(aTableView)
        aTableView.dataSource = self
        aTableView.delegate = self
        
        aTableView.separatorStyle = .None
        
        let nib = UINib(nibName: "ADTipLoginCell", bundle: nil)
        aTableView.registerNib(nib, forCellReuseIdentifier: loginCellId)
        
        aTableView.estimatedRowHeight = cellHeight
//        aTableView.tableHeaderView = displaySearchBar
        
        aTableView.tableHeaderView?.frame = CGRectMake(0, 0, screenWidth, 44)
       
        // displaySearchBar.delegate = self
        
//        mySearchDisplayController = UISearchDisplayController(searchBar: displaySearchBar, contentsController: self)
//        mySearchDisplayController.delegate = self
//        mySearchDisplayController.searchResultsDataSource = self
//        mySearchDisplayController.searchResultsDelegate = self

        self.addLoadMoreUI()
    }
    
    func imageWithColor(aColor: UIColor, aSize: CGSize) -> UIImage{
        let rect = CGRectMake(0, 0, aSize.width, aSize.height);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    func updateList() {
        currentListInx = 0
        
        self.loadData { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    func logOut(){
        self.unNetWorkFav.removeAll(keepCapacity: true)
        self.allFav.removeAll(keepCapacity: true)
        self.refreshData()
    }
    
    // MARK: refresh method
    func refreshData() {
        currentListInx = 0
        
        self.loadData { () -> Void in
            self.refreshControl.endRefreshing()
            self.aTableView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
    }
    
    func scrollToTopAndRefresh() {
        self.aTableView.scrollsToTop = true
        refreshControl.beginRefreshing()
        
        if(self.allFav.count != 0){
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.aTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            let time: NSTimeInterval = 0.8
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.refreshData()
            }
        }else{
            self.aTableView.setContentOffset(CGPointMake(0, -64 - 52), animated: false)
            self.refreshData()
        }
        
//        self.aTableView.scrollRectToVisible(CGRectMake(0, -64, screenWidth, self.aTableView.frame.size.height), animated: true)
//        refreshControl.beginRefreshing()
//
////        UIView.animateWithDuration(0.3, animations: { () -> Void in
////        })
//        let time: NSTimeInterval = 0.8
//        let delay = dispatch_time(DISPATCH_TIME_NOW,
//            Int64(time * Double(NSEC_PER_SEC)))
//        dispatch_after(delay, dispatch_get_main_queue()) {
//            self.aTableView.setContentOffset(CGPointMake(0, -64 - 52), animated: false)
//            self.refreshData()
//        }
    }

    func loadData(finish: () -> Void) {

        if loading {
            return;
        }
        loading = true
        var showLocalData = false
       
        if count(NSUserDefaults.standardUserDefaults().addingToken) == 0{
            showLocalData = true;
        }

        if showLocalData == false {
            let tmpLocalFav = ADMomLookDAO.getUnSyncMomLookContent()
            if tmpLocalFav.count != 0 {
                
                print("need upload \(tmpLocalFav.count) \n")
                self.unNetWorkFav.removeAll(keepCapacity: true)
                self.unNetWorkFav = self.getContentInfoWithMomInfos(tmpLocalFav, loc: 0, len: tmpLocalFav.count)
                self.allFav.removeAll(keepCapacity: true)
                self.allFav += self.unNetWorkFav
            }else{
                print("do not need upload \n")
            }
            
            MomLookCollectSyncHelper.getCollect(self.currentListInx, len: self.reqListLength, finish: { (res, err) -> Void in
                if (err != nil) {
                    self.refreshControl.endRefreshing()
                    if self.allFav.count > 0 {
                    } else {
                        self.aTableView.backgroundView =
                            ADFailLodingView(frame: CGRectMake(0, 0, screenWidth, screenHeight), tapBlock: { () -> Void in
                                self.aTableView.backgroundView =
                                    ADLoadingView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
                                self.loadData({ () -> Void in
                                })
                            })
                    }
                    self.loading = false
                } else if let resArray = res as? [AnyObject] {
                    //self.allFav.removeAll(keepCapacity: true)
//                        self.addUnSyncData()
                    
                    let finalArray = self.getContentInfoWithRequstRes(resArray)
                    if tmpLocalFav.count == 0 {
                        self.allFav.removeAll(keepCapacity: true)
                    }
                    self.allFav += finalArray
                    self.aTableView.reloadData()
                    
                    //println("all \(self.allFav) table \(self.aTableView)")
//                        //本地数据同时 更新为 取回来的数据
                 //   ADMomLookDAO.updateMomLookContentWithStartCollectId(Int(bitPattern:self.currentListInx), andLength: Int(bitPattern:self.reqListLength), andContents: finalArray)
                    
                    self.currentListInx = UInt(bitPattern:self.allFav.count)
                    
                    if self.allFav.count == 0 {
                        self.aTableView.backgroundView =
                        ADEmptyView(frame: CGRectMake(0, 0, screenWidth, screenHeight), title: "还没有任何收藏哦", image: UIImage(named: "list_loading_06"))
                    } else {
                        self.aTableView.backgroundView = nil
                    }
                    self.loading = false
                    finish()
                }

            })
            if tmpLocalFav.count != 0 {
                self.importData()
            }
            
        } else {
            let tmpLocalFav = ADMomLookDAO.getUnSyncMomLookContent()
            
            self.allFav.removeAll(keepCapacity: true)
            self.netWorkFav = self.getContentInfoWithMomInfos(tmpLocalFav, loc: 0, len: self.reqListLength)
            
//                self.addUnSyncData()
            self.allFav += self.netWorkFav
            
            print("n:\(self.netWorkFav) t:\(tmpLocalFav) a:\(self.allFav)")
//                dispatch_async(dispatch_get_main_queue(), {
                self.aTableView.reloadData()
                if self.allFav.count == 0 {
                    self.aTableView.backgroundView =
                    ADEmptyView(frame: CGRectMake(0, 0, screenWidth, screenHeight), title: "还没有任何收藏哦", image: UIImage(named: "list_loading_06"))
                } else {
                    self.aTableView.backgroundView = nil
                }
//                })
            
            self.currentListInx = UInt(bitPattern:self.allFav.count)
//                self.refreshControl.endRefreshing()
            println("listInx: \(self.currentListInx)")
            self.loading = false
            finish()
        }
//        })
    }
    
    func importData() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
            // 上传 未同步数据
            print("upload collect data\n")
            let tmpLocalFav = ADMomLookDAO.getUnSyncMomLookContent()
            println("tmp: \(tmpLocalFav)")
            self.unNetWorkFav = self.getContentInfoWithMomInfos(tmpLocalFav, loc: 0, len: tmpLocalFav.count)
            
            MomLookCollectSyncHelper.importCollect(self.unNetWorkFav, finish: { (res) -> Void in
                if let resArray = res as? [AnyObject] {
                    for aObject in resArray {
                        let aRealObject = aObject as! [String: AnyObject]
                        let action = aRealObject["action"] as! String
                        let collectId = aRealObject["collectId"] as! String

                        if (collectId == "0") {
                             if let err: String = aRealObject["error"] as? String {
                                if (err == "invalid action") {
                                    ADMomLookDAO.deleteCollectedContent(action)
                                } else {
                                    // 不删
                                }
                             } else {
                                ADMomLookDAO.deleteCollectedContent(action)
                            }
                        } else {
                           ADMomLookDAO.deleteCollectedContent(action)
                        }
                    }
                    let tmpLocalFav = ADMomLookDAO.getUnSyncMomLookContent()
                    self.unNetWorkFav = self.getContentInfoWithMomInfos(tmpLocalFav, loc: 0, len: tmpLocalFav.count)
                }
            })
        })
    }
    
    func addUnSyncData() {
        let tmpUnSyncData = ADMomLookDAO.getUnSyncMomLookContent()
        
        unNetWorkFav.removeAll(keepCapacity: false)
        for (var i:UInt = 0; i < tmpUnSyncData.count; i++) {
            let oldInfo = tmpUnSyncData[i] as! ADMomLookSaveContent
            let aInfo = self.getContentInfoWithMomInfo(oldInfo)
            unNetWorkFav.append(aInfo)
        }
        
        allFav += unNetWorkFav
    }
    
//    func updateCollectData(data: [AnyObject]) {
//        for (var i = 0; i < data.count; i++) {
//            let aInfo = ADMomContentInfo(modelObject: data[i])
//            let data = data[i] as! [String : AnyObject]
//            let cid = data["collectId"] as! String
//            ADMomLookDAO.updateMomLookContent(aInfo, andCollectId: cid)
//        }
//    }
    
    func changeCollectIdWithArray(changeArray: [AnyObject]) {
        for (var i = 0; i < changeArray.count;i++) {
            let aCollect = changeArray[i] as! [String : AnyObject]
            let act = aCollect["action"] as! String
            ADMomLookDAO.deleteCollectedContent(act)
        }
    }
    
    func getContentInfoWithMomInfo(aInfo: ADMomLookSaveContent) -> ADMomContentInfo {
        var images = NSMutableArray(capacity: 0)
        for (var i:UInt = 0; i < aInfo.images.count; i++) {
            var aImg: AnyObject! = aInfo.images[i]
            images.addObject(aImg.imageUrl)
        }
        return ADMomContentInfo(title: aInfo.title, andImgUrls:images as [AnyObject], andContentType:"\(aInfo.aContentType.value)", andContentStyle: "\(aInfo.aContentStyle)", andPublishTime: aInfo.aPublishTime, andMediaSource: aInfo.mediaSource, andDescription: aInfo.aDescription,  andAction: aInfo.action, andSaveDate: aInfo.saveDate, tagLabel: nil)
    }

    func getContentInfoWithMomInfos(infos: RLMResults) -> [ADMomContentInfo] {
        var contentRes = Array <ADMomContentInfo> ()
        for (var i:UInt = 0; i < infos.count; i++) {
            let oldInfo = infos[i] as! ADMomLookSaveContent
            
            let aInfo = self.getContentInfoWithMomInfo(oldInfo)
            contentRes.append(aInfo)
        }
        
        return contentRes
    }

    func getContentInfoWithMomInfos(infos: RLMResults, loc:UInt, len:UInt) -> [ADMomContentInfo] {
        var contentRes = [ADMomContentInfo]()
        
        var num: UInt = loc + len
        print("req loc: \(loc) num: \(num)")
        if num > infos.count {
            num = infos.count
        }
        for (var i = loc; i < num; i++) {
            let oldInfo = infos[i] as! ADMomLookSaveContent
            
            let aInfo = self.getContentInfoWithMomInfo(oldInfo)
            
            contentRes.append(aInfo)
        }
        
        print("contentRes: \(contentRes)")
        return contentRes
    }
    
    func getContentInfoWithRequstRes(aRes: [AnyObject]) -> [ADMomContentInfo] {
        var contentRes = Array <ADMomContentInfo> ()
        for (var i = 0; i < aRes.count; i++) {
            var aInfo = ADMomContentInfo(modelObject: aRes[i])
            println("info \(aInfo.contentId)")
            contentRes.append(aInfo)
        }
        
        return contentRes
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row
        let aInfo = allFav[row] as ADMomContentInfo
        
        self.jumpToDetailVc(aInfo, aRow: row)
//        println("channelId \(channelId), pos \(indexPath.row), contentId \(aInfo.contentId)")
    }
    
    func addLoadMoreUI() {
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        aTableView.addSubview(refreshControl)

        aTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.loadMore()
        }
        
        aTableView.showsInfiniteScrolling = true
        
        aTableView.infiniteScrollingView.hidden = true
    }
    
    func loadMore() {
        self.aTableView.infiniteScrollingView.startAnimating()

        var showLocalData = true
        if (count(NSUserDefaults.standardUserDefaults().addingToken) > 0) {
            showLocalData = false
        }
        
        if showLocalData == false {
            print("idx: \(currentListInx) req: \(reqListLength)")
            if loading{
                return;
            }
            MomLookCollectSyncHelper.getCollect(self.currentListInx, len: self.reqListLength, finish: { (res, err) -> Void in
                
                self.refreshControl.endRefreshing()
                if err != nil {
                    
                } else if let resArray = res as? [AnyObject] {
                    if resArray.count == 0 {
//                        self.scrollToBottom(self.aTableView)
                    } else {
                        let finalArray = self.getContentInfoWithRequstRes(resArray)
                        self.allFav += finalArray
                        self.aTableView.reloadData()
                        
                        //本地数据同时 更新为 取回来的数据
    //                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
//                        ADMomLookDAO.updateMomLookContentWithStartCollectId(
//                            Int(bitPattern:self.currentListInx), andLength: Int(bitPattern:self.reqListLength), andContents: finalArray)
//    //                            })
                        self.currentListInx = UInt(bitPattern:self.allFav.count)
                    }
                    
                    self.aTableView.infiniteScrollingView.stopAnimating()
                }
                self.loading = false
            })
        } else {
            let tmpLocalFav = ADMomLookDAO.getAllMomLookContent()
            allFav += self.getContentInfoWithMomInfos(tmpLocalFav, loc: currentListInx, len: reqListLength)
            
            aTableView.reloadData()
            currentListInx = UInt(bitPattern:allFav.count)
            aTableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    func scrollToBottom (aScrollView: UIScrollView) {
//        if aScrollView.contentSize.height - aScrollView.bounds.size.height > 0 {
//            aScrollView.setContentOffset(CGPointMake(0, aScrollView.contentSize.height - aScrollView.bounds.size.height), animated: true)
//        } else{
//            aScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
//        }
    }
    
    // 替换 title 带 <em>
    func hightLightArray(unHighLightArray: [ADMomContentInfo], highLightStr: String) -> [ADMomContentInfo] {
        var res = [ADMomContentInfo] ()
        for (var i = 0; i < unHighLightArray.count; i++) {
            let aData = unHighLightArray[i];
            
            let toReplaceStr = "<em>" + "\(highLightStr)" + "</em>"
            let newString = aData.title.stringByReplacingOccurrencesOfString(highLightStr, withString: toReplaceStr, options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            println("newString: \(newString)")
            aData.title = newString
            res.append(aData)
        }
        return res;
    }
}

extension ADMomLookCollectVC:UITableViewDelegate {
    func jumpToDetailVc(aMomInfo: ADMomContentInfo, aRow: Int) {
        var actionPre = aMomInfo.action.componentsSeparatedByString("?")[0]
//        println("action: \(aMomInfo)")
        if (actionPre == action.content) {
            var aDetailVc = ADMomLookContentDetailVC()
            aDetailVc.contentModel = aMomInfo
            //for ad stat
            aDetailVc.aChannelId = "\(8)"
            aDetailVc.aIndex =  "\(aRow)"
            aDetailVc.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(aDetailVc, animated: true)
        }
        
        if (actionPre == action.webview) {
            var adVc = ADAdWebVC()
            adVc.action = aMomInfo.action
            //for ad stat
            adVc.isAd = true
            adVc.cId = "\(8)"
            adVc.positionInx = "\(aRow)"
//            adVc.adId = _allMomLookOriginContentArray[indexPath.row][@"adId"];
            
            self.navigationController?.pushViewController(adVc, animated: true)
        }
    }
    
    func setupCell(aCell: ADMomLookContentTableViewCell, aIndexPath: NSIndexPath, aInfo: ADMomContentInfo) {
        
        aCell.selectionStyle = .None
            
        
        aCell.aMomLookInfo = aInfo
        
        if aInfo.imgUrls.count > 0 {
            let targetImgUrl = NSURL(string:aInfo.imgUrls[0] as! String)
            aCell.thumbImgView.sd_setImageWithURL(targetImgUrl, placeholderImage: nil, options: .HandleCookies, completed: { (img, err, cacheType, imgUrl) -> Void in
            if img == nil{
            }
        
            })
            
        }else{
            aCell.thumbImgView.image = UIImage(named: "加丁号文章默认")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if tableView == self.mySearchDisplayController.searchResultsTableView {
//            return cellHeight
//        } else {
//            if (indexPath.row == 0 && count(NSUserDefaults.standardUserDefaults().addingToken) == 0) {
//                return 40
//            } else {
                return cellHeight
//            }
//        }
    }
}

extension ADMomLookCollectVC:UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(collectCellId) as! ADMomLookContentTableViewCell!
        if (cell == nil) {
            cell = ADMomLookContentTableViewCell(style: .Default, reuseIdentifier: collectCellId)
        }
        var row = 0
        row = indexPath.row
        let info = allFav[row] as ADMomContentInfo
        if(info.isKindOfClass(ADMomContentInfo)){
            self.setupCell(cell, aIndexPath: indexPath, aInfo:info)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if tableView == self.mySearchDisplayController?.searchResultsTableView {
//            return findFav.count
//        } else {
//            if (count(NSUserDefaults.standardUserDefaults().addingToken) > 0) {
        
        if allFav.count > 0 {
            aTableView.backgroundView = nil
        }
        return allFav.count
//            } else {
//                return allFav.count + 1
//                //            return Int(bitPattern: localFav.count) + 1
//            }
//        }
    }
}

extension ADMomLookCollectVC:UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentSize.height > screenHeight - 49 - 64 - 20) {
            aTableView.infiniteScrollingView.hidden = false
            aTableView.showsInfiniteScrolling = true
        } else {
            aTableView.infiniteScrollingView.hidden = true
            aTableView.showsInfiniteScrolling = false
        }
        
//        if scrollView != self.mySearchDisplayController.searchResultsTableView {
//            self.aTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 49 - 64)
//        }
        
    }
}

extension ADMomLookCollectVC:UISearchDisplayDelegate {
 
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {

//        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
//        self.displaySearchBar.transform = CGAffineTransformMakeTranslation(0, 20)
//        UIView.animateWithDuration(0.01, animations: { () -> Void in
//            println("change \(statusBarFrame.size.height)")
//            for subView in self.displaySearchBar.subviews {
////                subView as! UIView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height)
////                subView.transform
//            }
//        })

        //        self.mySearchDisplayController.searchResultsTableView.delegate = self
//        self.tabBarController!.tabBar.hidden = true
    }
    
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
//        self.navigationController?.navigationBarHidden = true
    }
    
    func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController) {
//        self.navigationController?.navigationBarHidden = false
        self.tabBarController!.tabBar.hidden = false
//        shadeStatusView.removeFromSuperview()
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
//        self.aTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 49 - 64)
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
////            self.aTableView.setContentOffset(CGPointMake(0, -20), animated: false)
//            self.aTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 49 - 64)
//        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
//        self.view.bringSubviewToFront(shadeStatusView)
//        bringSubviewToFront
        findFav.removeAll(keepCapacity: true)
        if searchString == "" {
        } else {
            if count(NSUserDefaults.standardUserDefaults().addingToken) > 0 {
                if AFNetworkReachabilityManager.sharedManager().reachable == true {
                    MomLookCollectSyncHelper.searchCollect(searchString, finish: { (res) -> Void in
                        if let resArray = res as? [AnyObject] {
                            let finalArray = self.getContentInfoWithRequstRes(resArray)
                            
                            let unSyncRes = ADMomLookDAO.searchUnSyncDataWithString(searchString)
//                            let unSyncArray = self.getContentInfoWithMomInfos(unSyncRes, 0, unSyncRes.count)
                            let unSyncArray = self.getContentInfoWithMomInfos(unSyncRes)
                            let finialHighTitle = self.hightLightArray(unSyncArray, highLightStr: searchString)
                            self.findFav += finialHighTitle
                            self.findFav += finalArray
//                            self.mySearchDisplayController.searchResultsTableView.reloadData()
                        }
                    })
                } else {
                    // 登陆 无网
                    // 本地搜索 本地缓存 未网络化数据
                    let searchRes = ADMomLookDAO.searchLocalDataWithString(searchString)
                    let searchArray = self.getContentInfoWithMomInfos(searchRes)
                    let finialHighTitle = self.hightLightArray(searchArray, highLightStr: searchString)
                    self.findFav += finialHighTitle
                    
//                    self.mySearchDisplayController.searchResultsTableView.reloadData()

                    print("searchRes: \(searchRes)")
                }
            } else {
                // 未登录
                // 本地搜索
                let searchRes = ADMomLookDAO.searchLocalDataWithString(searchString)
                let searchArray = self.getContentInfoWithMomInfos(searchRes)
                let finialHighTitle = self.hightLightArray(searchArray, highLightStr: searchString)
                self.findFav += finialHighTitle
                
//                self.mySearchDisplayController.searchResultsTableView.reloadData()

                print("searchRes: \(searchRes)")
            }
        }
        return true
    }
}