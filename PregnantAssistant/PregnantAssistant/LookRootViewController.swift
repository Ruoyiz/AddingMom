//
//  ViewController.swift
//  tabNaviSearchBarDemo
//
//  Created by D on 15/6/16.
//  Copyright (c) 2015年 D. All rights reserved.
//

import UIKit

class LookRootViewController: UIViewController {
    
    let titleSelectView = HTHorizontalSelectionList(frame: CGRectMake(0, 0, screenWidth, 44))
    let titles = ["加丁推荐", "订阅", "收藏"]
    let pageVc = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    var contentVcs = [UIViewController]()
    let redDot = UIView(frame: CGRectMake(0, 0, 6, 6))
    let redDot2 = UIView(frame: CGRectMake(0, 0, 6, 6))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = true
        
        pageVc.dataSource = self
        pageVc.delegate = self

        contentVcs.append(ADRecommandVC())
        
        var feedVc = ADFeedInPageViewController()
        feedVc.channelId = 7
        contentVcs.append(feedVc)
        
        contentVcs.append(ADMomLookCollectVC())

        self.automaticallyAdjustsScrollViewInsets = false

        self.switchContentVcAtIndex(0)
        
        pageVc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.addChildViewController(pageVc)
        view.addSubview(pageVc.view)
        
        self.setupNaviBar()
//        self.showDotAtTitle(1)
//        self.showDotAtTitle(0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addDot1", name: addMomLookTitleDot1Notification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addDot2", name: addMomLookTitleDot2Notification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rmDot1", name: removeMomLookTitleDot1Notification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rmDot2", name: removeMomLookTitleDot2Notification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doubleTaped", name: "RefreshLookDataNoti", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
    }
    
    func setupNaviBar() {
        titleSelectView.delegate = self
        titleSelectView.dataSource = self
        titleSelectView.selectionIdicatorAnimationMode = .LightBounce
        titleSelectView.selectionIndicatorColor = UIColor.blackColor()
        
        titleSelectView.setTitleFont(UIFont(name: "FZLanTingHei-L-GBK", size: 15), forState: UIControlState.Normal)
        titleSelectView.setTitleFont(UIFont(name: "FZLanTingHei-L-GBK", size: 15), forState: UIControlState.Selected)
        titleSelectView.setTitleFont(UIFont(name: "FZLanTingHei-L-GBK", size: 15), forState: UIControlState.Highlighted)
        
        titleSelectView.setTitleColor(UIColor.title_unSelect_Color(), forState: UIControlState.Normal)
        titleSelectView.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        
        titleSelectView.backgroundColor = UIColor.clearColor()
        titleSelectView.bottomTrimHidden = true

        print(titleSelectView.frame.size.width)
        var searchBar = UIButton(frame: CGRectMake(0, 0, 44, 44))

        searchBar.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        searchBar.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        searchBar.setImage(UIImage(named: "searchBar"), forState: UIControlState.Normal)
        searchBar.backgroundColor = UIColor .clearColor()
        searchBar.addTarget(self, action: "searchBarClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleSelectView
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func addDot1() {
        self.showDotAtTitle(0)
    }
    
    func addDot2() {
        self.showDotAtTitle(1)
    }
    
    func searchBarClicked(){
        
        MobClick.event(search_click)
        let vc = ADSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showDotAtTitle(idx: Int) {
        if (idx == 0) {
            if (redDot.superview == nil) {
                redDot.center = CGPointMake(73, 19)
                redDot.backgroundColor = UIColor.red_Dot_color()
                redDot.layer.cornerRadius = redDot.frame.size.height / 2.0
                redDot.clipsToBounds = true
                titleSelectView.addSubview(redDot)
            }
            redDot.alpha = 1;
            
        } else if (idx == 1) {
            if redDot2.superview == nil{
                redDot2.center = CGPointMake(123, 19)
                redDot2.backgroundColor = UIColor.red_Dot_color()
                redDot2.layer.cornerRadius = redDot.frame.size.height / 2.0
                redDot2.clipsToBounds = true
                
                titleSelectView.addSubview(redDot2)
            }
            redDot2.alpha = 1;
        }
    }
    
    func rmDot1() {
        //redDot.removeFromSuperview()
        redDot.alpha = 0
        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleAllDotNotification, object: nil)

    }
    
    func rmDot2() {
        //redDot2.removeFromSuperview()
        redDot2.alpha = 0
        NSNotificationCenter.defaultCenter().postNotificationName(removeMomLookTitleAllDotNotification, object: nil)
    }
    
    //双击手势刷新
    func doubleTaped(){
        let vc = pageVc.viewControllers[0] as! UIViewController
        if vc.isKindOfClass(ADRecommandVC) || vc .isKindOfClass(ADFeedInPageViewController){
            let currentVc = vc as! ADBaseContentListVC
            currentVc.scrollToTopAndRefresh()
        }else{
            let currentVc = vc as! ADMomLookCollectVC
            currentVc.scrollToTopAndRefresh()
        }
        
    }
    
    func switchContentVcAtIndex(idx: Int) {
        //UIPageViewControllerNavigationDirection direction = (aIndex > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        var direction = UIPageViewControllerNavigationDirection.Forward;
       
        let currentVc = pageVc.viewControllers[0] as! UIViewController
        let vcIdx = self.indexOfViewController(currentVc)
        if idx < vcIdx {
            direction = UIPageViewControllerNavigationDirection.Reverse
        }
        pageVc.setViewControllers([contentVcs[idx]], direction:direction, animated: true, completion:nil)
    }
}

extension LookRootViewController:HTHorizontalSelectionListDataSource {
    func numberOfItemsInSelectionList(selectionList: HTHorizontalSelectionList!) -> Int {
        return titles.count
    }
    
    func selectionList(selectionList: HTHorizontalSelectionList!, titleForItemWithIndex index: Int) -> String! {
        return titles[index]
    }
}

extension LookRootViewController:HTHorizontalSelectionListDelegate {
    func selectionList(selectionList: HTHorizontalSelectionList!, didSelectButtonWithIndex index: Int) {
        self.switchContentVcAtIndex(index)
    }
    
    func didSelectSameButtonAtIndex(index: Int) {
//        println("same")
        
        if contentVcs[index] is ADBaseContentListVC {
            let vc = contentVcs[index] as! ADBaseContentListVC
            vc.scrollToTopAndRefresh()
        }
        if contentVcs[index] is ADMomLookCollectVC {
            let vc = contentVcs[index] as! ADMomLookCollectVC
            vc.scrollToTopAndRefresh()
        }
    }
}

extension LookRootViewController:UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        let currentVc = pageVc.viewControllers[0] as! UIViewController
        let vcIdx = self.indexOfViewController(currentVc)
        
        titleSelectView.setSelectedButtonIndex(vcIdx, animated: true)
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        let nextVc = pendingViewControllers[0] as! UIViewController
        let vcIdx = self.indexOfViewController(nextVc)
        
        titleSelectView.setSelectedButtonIndex(vcIdx, animated: true)
    }
}

extension LookRootViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index < 0 || index >= self.contentVcs.count {
            return nil
        }
        
        return contentVcs[index]
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        for var i = 0; i < self.contentVcs.count; i++ {
            if viewController == self.contentVcs[i] {
                return i
            }
        }
        return NSNotFound
    }
}