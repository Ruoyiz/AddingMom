//
//  CustomPicker.swift
//  
//
//  Created by D on 15/6/29.
//
//

import UIKit
enum pickerType {
    case date
    case select
    case circle
}

class CustomPicker: ADBaseCustomPicker {

    var myPickerType: pickerType!
    
    let selectPicker = UIPickerView(frame:  CGRectMake(0, 40, screenWidth, 216))
    let datePicker = UIDatePicker(frame:  CGRectMake(0, 40, screenWidth, 216))

    var leftBtn = UIButton(frame: CGRectMake(0, 68, 127, 127))
    var rightBtn = UIButton(frame: CGRectMake(0, 68, 127, 127))
    var Llabel = UILabel(frame: CGRectMake(0, 0, 100, 40))
    var Rlabel = UILabel(frame: CGRectMake(0, 0, 100, 40))
    
    var selectValue: AnyObject!
    var toSelectRow = 0
    
    func showInView(aView: UIView) {
        self.removeContent()
        
        if myPickerType == pickerType.select {
            selectPicker.dataSource = self
            selectPicker.delegate = self
            
//            var toSelectRow = find(_dataSource, selectValue)
            selectRow = toSelectRow
            selectPicker.selectRow(toSelectRow, inComponent: 0, animated: false)
            self.addSubview(selectPicker)
        } else if myPickerType == pickerType.date {
            datePicker.datePickerMode = UIDatePickerMode.Date
            self.addSubview(datePicker)
        }
        
        if animating {
            return
        }
        
        aView.addSubview(self)
        
        UIView.animateWithDuration(0.8, delay: 0,
            usingSpringWithDamping: 1.2,
            initialSpringVelocity: 15,
            options: nil,
            animations: {
                self.frame = CGRectMake(0, screenHeight - (216 + 40), screenWidth, 216)
                self.animating = true
            }, completion: {(finish) -> Void in
                self.animating = false
        })
    }
    
    func removeContent() {
        selectPicker.removeFromSuperview()
        datePicker.removeFromSuperview()
        leftBtn.removeFromSuperview()
        rightBtn.removeFromSuperview()
        Llabel.removeFromSuperview()
        Rlabel.removeFromSuperview()
    }
    
//    func addBtnAndLabel() {
//        //addbtn
//        leftBtn.setImage(UIImage(named: "1-1"), forState: UIControlState.Normal)
//        leftBtn.setImage(UIImage(named: "1-2"), forState: UIControlState.Selected)
//        leftBtn.addTarget(self, action: "selectLeft", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        leftBtn.center = CGPointMake(screenWidth / 4, leftBtn.center.y)
//        
//        rightBtn.setImage(UIImage(named: "2-1"), forState: UIControlState.Normal)
//        rightBtn.setImage(UIImage(named: "2-2"), forState: UIControlState.Selected)
//        rightBtn.addTarget(self, action: "selectRight", forControlEvents: UIControlEvents.TouchUpInside)
//
//        rightBtn.center = CGPointMake(screenWidth / 4 * 3, leftBtn.center.y)
//        
//        self.addSubview(leftBtn)
//        self.addSubview(rightBtn)
//        
//        Llabel.text = "孕期"
//        Llabel.textAlignment = NSTextAlignment.Center
//        Llabel.font = UIFont.systemFontOfSize(14)
//
//        Llabel.center = CGPointMake(leftBtn.center.x, leftBtn.center.y + 64 + 17)
//        self.addSubview(Llabel)
//        
//        Rlabel.text = "育儿"
//        Rlabel.textAlignment = NSTextAlignment.Center
//        Rlabel.font = UIFont.systemFontOfSize(14)
//        Rlabel.center = CGPointMake(rightBtn.center.x, rightBtn.center.y + 64 + 17)
//        self.addSubview(Rlabel)
//        
//        if (leftBtn.selected) {
//            Llabel.textColor = UIColor.select_title_color()
//            Rlabel.textColor = UIColor.unselect_title_color()
//        } else {
//            Llabel.textColor = UIColor.unselect_title_color()
//            Rlabel.textColor = UIColor.select_title_color()
//        }
//    }
    
//    func selectLeft() {
//        leftBtn.selected = true
//        rightBtn.selected = false
//        Llabel.textColor = UIColor.select_title_color()
//        Rlabel.textColor = UIColor.unselect_title_color()
//    }
//    
//    func selectRight() {
//        leftBtn.selected = false
//        rightBtn.selected = true
//        Rlabel.textColor = UIColor.select_title_color()
//        Llabel.textColor = UIColor.unselect_title_color()
//    }
    
    func done() {
        self.hide(true)
        
        var selectThing:AnyObject
        if myPickerType == pickerType.select {
            selectThing = _dataSource[selectRow]
        } else if myPickerType == pickerType.date {
            selectThing = datePicker.date
        } else {
            if leftBtn.selected == true {
                selectThing = "孕期"
            } else {
                selectThing = "育儿"
            }
        }
        delegate.didFinishSelect(selectThing)
    }
}

extension CustomPicker:UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _dataSource.count
    }
}

extension CustomPicker:UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return _dataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
}