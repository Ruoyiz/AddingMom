//
//  ADBaseVC.swift
//  
//
//  Created by D on 15/7/6.
//
//

import UIKit

class ADBaseVC: UIViewController {

    var myTitle:String? {
        set {
            if let value = newValue {
                var titleLable = UILabel(frame: CGRectMake(0, 0, 100, 42))
                titleLable.font = UIFont.ADBlackTitleFont()
                titleLable.textColor = UIColor.title_black_color()
                titleLable.text = newValue
                titleLable.textAlignment = .Center
                self.navigationItem.titleView = titleLable
            } else {
                _myTitle = nil;
            }
        }
        
        get {
            return _myTitle!
        }
    }

    var _myTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setBlackBack() {
        var btn = UIButton(frame: CGRectMake(0, 0, 24, 24))
        btn.addTarget(self, action: Selector("back"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setImage(UIImage(named: "navBack"), forState: UIControlState.Normal)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4)
        
//        [backButton setFrame:CGRectMake(0, 0, 24, 24 +4)];
//        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];


        var btnItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = btnItem
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}