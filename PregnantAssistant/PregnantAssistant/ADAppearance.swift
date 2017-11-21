//
//  ADAppearance.swift
//  
//
//  Created by D on 15/7/7.
//
//

import UIKit

class ADAppearance: NSObject {
    class func initAppAppearance() {
        UITextView.appearance().tintColor = UIColor.btn_green_bgColor()
        UITextField.appearance().tintColor = UIColor.btn_green_bgColor()
        UIWebView.appearance().tintColor = UIColor.defaultTintColor()
        
        let cancelBtnAttributes = [NSForegroundColorAttributeName: UIColor.btn_green_bgColor()]
        let disEnableBtnAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelBtnAttributes, forState: UIControlState.Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(disEnableBtnAttributes, forState: UIControlState.Disabled)
        
//        let appearanceNavigationBar = UINavigationBar.appearance()
//        
////        UINavigationBar* appearanceNavigationBar = [UINavigationBar appearance];
//        //the appearanceProxy returns NO, so ask the class directly
////        if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)])
//        {
//            appearanceNavigationBar.backIndicatorImage = [UIImage imageNamed:@"back"];
//            appearanceNavigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
//            //sets back button color
//            appearanceNavigationBar.tintColor = [UIColor whiteColor];
//        }
    }
}
