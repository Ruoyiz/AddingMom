//
//  ADBaseContentListVC.swift
//  
//
//  Created by D on 15/7/7.
//
//

import UIKit

class ADBaseContentListVC: UIViewController {

    var myTableView :UITableView!
    var tableViewData = [ADMomContentInfo]()
    var cellId = "lookCell"
    var currentIdx = 0
    let reqLength = 8
    let refreshControl = UIRefreshControl(frame: CGRectMake(0, 0, screenWidth, 40))
    var channelId = 1
    var currentContentId = "0"
    var cellCache = NSCache()
    var loadedData = false
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight), style: .Plain)
        
        self.setExtraCellLineHidden()
        
        view.addSubview(myTableView)
        myTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        myTableView.setContentOffset(CGPointMake(0, -64), animated: false)
        myTableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
//        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
//        if iOS7 {
//            myTableView.dx_debuglogEnabled = false
//        }

//        myTableView.registerNib(UINib(nibName: "DTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
//        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        myTableView.registerClass(ADBaseLookTableViewCell.self, forCellReuseIdentifier: cellId)
        myTableView.backgroundView = ADLoadingView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(self.loadedData == false){
            self.loadData()
        }
        
        loadedData = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.navigationBar.translucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setExtraCellLineHidden() {
        var view = UIView()
        view.backgroundColor = UIColor.clearColor()
        myTableView.tableFooterView = view
    }
    
    func addRefreshAndInfi() {
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        myTableView.addSubview(refreshControl)
        
//        print("tableview: \(self.myTableView)")
        myTableView.addInfiniteScrollingWithActionHandler { () -> Void in
            self.loadMore()
        }
        
        myTableView.showsInfiniteScrolling = true
    }
    
    func loadData() {
    }

    func refreshData() {
    }
    
    func loadMore() {
    }
    
    func finishLoadData(){
        let time: NSTimeInterval = 0.7
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.loading = false
        }
    }
    
    func scrollToTopAndRefresh() {
        if  loading == true {
            
            return
        }
        
        loading = true
        
        refreshControl.beginRefreshing()
        self.myTableView.scrollsToTop = true
        //self.myTableView.scrollRectToVisible(CGRectMake(0, -64, screenWidth, self.myTableView.frame.size.height), animated: true)

        if tableViewData.count != 0{
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.myTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            let time: NSTimeInterval = 0.8
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.refreshData()
            }
        }else{
            self.myTableView.setContentOffset(CGPointMake(0, -64 - 52), animated: false)
            self.refreshData()
        }
        
    }
}

extension ADBaseContentListVC:UITableViewDelegate {

    func heightForAttributedString(txt: NSAttributedString, maxWidth: CGFloat) -> CGFloat {
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading
        let size =
        txt.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: options, context: nil).size
        return size.height + 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let entity = tableViewData[indexPath.row]
        let cell = self.prepareCell(tableView, indexPath: indexPath, data: entity)
        return cell.bounds.size.height
    }

    func prepareCell(tableView: UITableView, indexPath: NSIndexPath, data: ADMomContentInfo) -> ADBaseLookTableViewCell {
        let key = "\(indexPath.section)-\(indexPath.row)"
        var cell = cellCache.objectForKey(key) as! ADBaseLookTableViewCell!
        if (cell == nil) {
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! ADBaseLookTableViewCell
            cell.entity = data
            cell.delegate = self
            cellCache.setObject(cell, forKey: cellId)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let aMomInfo = tableViewData[indexPath.row]
        let actionPre = aMomInfo.action.componentsSeparatedByString("?")[0]
        
        if actionPre == action.content {
            var aDetailVc = ADMomLookContentDetailVC()
            aDetailVc.contentModel = aMomInfo
            aDetailVc.aChannelId = "\(self.channelId)"
            aDetailVc.aIndex = "\(indexPath.row)"
            ADAdStatHelper.shareInstance().clickContentOnChannelId("\(channelId)", andPosIndex: "\(indexPath.row)", andContentId: aMomInfo.contentId)
            self.navigationController?.pushViewController(aDetailVc, animated: true)
            
        } else if actionPre == action.webview {
            var aWebVc = ADAdWebVC()
            aWebVc.action = aMomInfo.action
            aWebVc.isAd = true
            
            self.navigationController?.pushViewController(aWebVc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var realRow = indexPath.row
        if realRow % 15 == 0 {
            ADAdStatHelper.shareInstance().showAdOnChannel("\(channelId)", atPos: "\(realRow)")
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let aCell = cell as! ADBaseLookTableViewCell
        aCell.cancelDownLoadImg()
    }
}

extension ADBaseContentListVC:LookCellDelegate {
    func titleClicked(index: Int) {
        let entity = tableViewData[index]
        print(entity.mediaId);
        let fvc = ADFeedDetailsViewController();
        fvc.mediaId = entity.mediaId;
        self.navigationController?.pushViewController(fvc, animated: true)
    }
}

extension ADBaseContentListVC:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData.count > 0 {
            tableView.backgroundView = nil
        }

        return tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let entity = tableViewData[indexPath.row]
    
        let cell = self.prepareCell(tableView, indexPath: indexPath, data: entity)
        cell.coverButton.tag = indexPath.row
        cell.selectionStyle = .None
        //        if iOS7 {
//        cell.dx_enforceFrameLayout = false
        //        }


//        if tableView.dragging == false && tableView.decelerating == false {
//            cell.contentImgView.image = nil

        if (entity.aContentStyle.value == contentOnlyTextStyle.value) {
        } else {
            cell.setImgWithUrlString(entity.imgUrls[0] as! String, type: entity.aContentStyle)
        }

        let url = NSURL(string: entity.addingUserLogoUrl)
//        cell.userImage.sd_setImageWithURL(url)

        cell.userImage.sd_setImageWithURL(url, completed: { (img, err, cacheType, url) -> Void in
        })

        print(url)

        return cell
    }
    
    func configureCell(cell: ADBaseLookTableViewCell, entity: ADMomContentInfo, indexPath: NSIndexPath) -> Void {
        cell.entity = entity

//        cell.bottomView.tag = indexPath.row
//        cell.bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "jumpToUser:"))
    }
}

/*
extension ADBaseContentListVC: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImgOnScreen()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImgOnScreen()
    }
    
    func loadImgOnScreen() {
        if (tableViewData.count > 0) {
            let visiblePaths = myTableView.indexPathsForVisibleRows()
//            for aPath in visiblePaths {
//
//            }
        }
    }
}
*/