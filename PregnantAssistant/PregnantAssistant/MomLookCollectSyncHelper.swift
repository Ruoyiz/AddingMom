//
//  MomLookCollectSyncHelper.swift
//  PregnantAssistant
//
//  Created by D on 15/6/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

import Foundation

class MomLookCollectSyncHelper: NSObject {
    class func importCollect(infos: Array<AnyObject>, finish: (res: AnyObject) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        let data = self.buildData(infos)
        var param = ["oauth_token": oAuth, "data": data]
        println("param:\(param)")
        manager.POST("\(baseApiUrl)/adcollect/importCollect", parameters: param, success: { (let operation, var resObject) -> Void in
            finish(res: resObject)
        }) { (var operation, var err) -> Void in
            println("err: \(err)")
        }
    }
    
    class func buildData(datas: Array<AnyObject>) -> NSString {
        var res = NSMutableArray(capacity: 0)
        
        for (var i = 0; i < datas.count; i++) {
            var aData = datas[i] as! ADMomContentInfo
            var dataDic = ["action": aData.action]
            
            res.addObject(dataDic)
        }
        
        return res.JSONString()
    }
    
    class func getCollect(loc:UInt, len:UInt, finish: (res: AnyObject!, err: NSError!) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        var param = ["oauth_token": oAuth, "start": loc, "size": len]
        let urlString = "\(baseApiUrl)/adcollect/getCollectList"
        println("url:\(urlString),get collect param:\(param)")
        manager.GET(urlString, parameters: param, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("res \(responseObject) \n")
                if let resArray = responseObject as? NSArray {
                    println("get collect response:\(resArray.count)")
                    finish(res: resArray, err: nil)
                }
            }) { (var operation, var err) -> Void in
                println("get err: \(err)")
               finish(res: nil, err: err)
        }
    }

    class func collect(action:String, finish: (collectId: NSString, err: NSError?) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        var param = ["oauth_token": oAuth, "action": action]
        println("create collect param:\(param)")
        manager.POST("\(baseApiUrl)/adcollect/createCollect", parameters: param, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("collect response : \(responseObject)")
            if let resDic = responseObject as? [String : AnyObject] {
                var collectId:AnyObject? = resDic["collectId"]
//                if count(resDic["error"] as String) > 0 {
//                    let err = NSError(domain: "com.addinghome", code: 1, userInfo: nil)
//                    finish(collectId: "", err: err)
//                } else {
                    finish(collectId: "\(collectId)", err: nil)
//                }
            }

            }) { (var operation, var err) -> Void in
                println("err: \(err)")
                finish(collectId: "", err: err)
        }
    }
    
    class func unCollect(collectId: String, finish: (err: NSError?) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        var param = ["oauth_token": oAuth, "collectId": collectId]
//        let
        println("qu xiao collect param:\(param)")
        manager.POST("\(baseApiUrl)/adcollect/deleteCollect", parameters: param, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            println("qu xiao collect get JSON: \(responseObject)")
            let resArray = responseObject as? NSArray
            finish(err: nil)
            }) { (var operation, var err) -> Void in
                println("err: \(err)")
                finish(err: err)
        }
    }
    
    class func searchCollect(searchStr: String, finish: (res: AnyObject) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        var param = ["oauth_token": oAuth, "keyword": searchStr]

        println("param:\(param)")
        manager.POST("\(baseApiUrl)/adcollect/searchCollect", parameters: param, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            let resArray = responseObject as! NSArray
//            println("get JSON: \(resArray)")
            finish(res: resArray)
            }) { (var operation, var err) -> Void in
                println("err: \(err)")
        }
    }

    class func isCollect(action: String, finish: (isCollect: Bool, collectId: String) -> Void) {
        var manager = ADBaseRequest.shareInstance()
        var oAuth = NSUserDefaults.standardUserDefaults().addingToken
        
        var param = ["oauth_token": oAuth, "action": action]
        manager.POST("\(baseApiUrl)/adcollect/getCollect", parameters: param, success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            
            if let resDic = responseObject as? [String : AnyObject] {
            //            println("get JSON: \(resArray)")
            
                let res = resDic["existed"] as! Bool
                var collectId = ""
                if resDic["collectId"] is String {
                   collectId = resDic["collectId"] as! String
                }
                println("ex: \(res)")
                
//                finish(isCollect: res)
                finish(isCollect: res, collectId: "\(collectId)")
            }
            
            }) { (var operation, var err) -> Void in
                println("err: \(err)")
        }

    }
}
