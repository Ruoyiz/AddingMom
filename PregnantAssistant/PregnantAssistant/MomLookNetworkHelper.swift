//
//  MomLookNetworkHelper.swift
//  
//
//  Created by D on 15/6/24.
//
//

import UIKit

class MomLookNetworkHelper: NSObject {
    
    class func getContentList(channelId:Int, contentId:String, start: Int, size: Int, finish: (res: [AnyObject]!, err: NSError!) -> Void) {
        var aRequest = ADBaseRequest.shareInstance()
        
        var delegate = UIApplication.sharedApplication().delegate as! ADAppDelegate
//        delegate.babyBirthday
//        var duedateStr = "\(ADHelper.getDueDate().timeIntervalSince1970)"
        
        var param = self.getBasicParam()
//        param["duedate"] = duedateStr
        param["channelId"] = channelId
        param["start"] = start
        param["size"] = size
        if count(contentId) > 0 {
            param["contentId"] = contentId
//        }else{
//            param["contentId"] = contentId
        }
        
        //记录请求时间
        if channelId == 1 {
            // 推荐
            NSUserDefaults.standardUserDefaults().momLookListRequestTime = NSDate()
        } else if channelId == 7 {
            // 订阅
            NSUserDefaults.standardUserDefaults().momLookFeedListRequestTime = NSDate()
        }
        
        aRequest.POST("\(baseApiUrl)/adco/v2.1/getContentList", parameters: param, success: { (operation, resObject) -> Void in
            if let reqArray = resObject as? [AnyObject] {
                var resArray = [ADMomContentInfo]()
                for (var i = 0; i < reqArray.count; i++) {
                    resArray.append(ADMomContentInfo(modelObject: reqArray[i]))
                }
                finish(res: resArray, err: nil)
            }
            }) { (operation, err) -> Void in
                println("err: \(err)")
                finish(res: nil, err: err)
        }
    }
    
    class func getBasicParam() -> [String: AnyObject] {
        var param = [String: AnyObject]()
        var delegate = UIApplication.sharedApplication().delegate as! ADAppDelegate

        if (ADLocationManager.shareLocationManager().location != nil) {
            param["longitude"] = ADLocationManager.shareLocationManager().location.longitude
            param["latitude"] = ADLocationManager.shareLocationManager().location.latitude
            if let pr = ADLocationManager.shareLocationManager().location.province {
                param["pr"] = pr
            }
    
            if let ci = ADLocationManager.shareLocationManager().location.city {
                param["ci"] = ci
            }
        }
        
        param["oauth_token"] = NSUserDefaults.standardUserDefaults().addingToken
        param["userStatus"] = delegate.userStatus
        if delegate.userStatus == "1" {
            let dueDate = delegate.dueDate.timeIntervalSince1970
            param["duedate"] = "\(dueDate)"
        } else {
            let babyBirthDay = delegate.babyBirthday.timeIntervalSince1970
            param["birthdate"] = "\(babyBirthDay)"
        }
        
        return param
    }
}
