//
//  ADBaseCustomPicker.swift
//  
//
//  Created by D on 15/7/8.
//
//

import UIKit
protocol customPickerDelegate {
    func didFinishSelect(res:AnyObject)
}

class ADBaseCustomPicker: UIView {
    var delegate:customPickerDelegate!
    var _dataSource = [String]()
    var selectRow = 0
    let doneBtn = UIButton(frame: CGRectMake(screenWidth - 60, 0, 60, 40))
    var tipLabel:UILabel!

    var tip:String? {
        set {
            if let value = newValue {
                tipLabel.text = newValue
            } else {
                _tip = nil;
            }
        }
        
        get {
            return _tip!
        }
    }
    
    var _tip:String?
    
    var animating = false
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgToolBar = UIToolbar(frame: CGRectMake(0, 0, frame.size.width, 40))
        bgToolBar.barStyle = UIBarStyle.Default
        self.addSubview(bgToolBar)
        
        doneBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneBtn.setTitle("确定", forState: UIControlState.Normal)
        doneBtn.setTitleColor(UIColor.btn_green_bgColor(), forState: UIControlState.Normal)
        doneBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        doneBtn.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        
        bgToolBar.addSubview(doneBtn)
        
        tipLabel = UILabel(frame: CGRectMake(14, 0, 300, 40))
        tipLabel.font = UIFont.systemFontOfSize(14)
        bgToolBar.addSubview(tipLabel)
    }
    
    func hide(animated: Bool) {
        if animated == false {
            self.frame = CGRectMake(0, screenHeight, screenWidth, 216)
            self.removeFromSuperview()
        } else {
            if animating {
                return
            }
            
            UIView.animateWithDuration(0.4, delay: 0,
                usingSpringWithDamping: 1.2,
                initialSpringVelocity: 15,
                options: nil,
                animations: {
                    self.frame = CGRectMake(0, screenHeight, screenWidth, 216)
                    self.animating = true
                }, completion: {(finish) -> Void in
                    self.removeFromSuperview()
                    self.animating = false
            })
        }
    }
    
}
