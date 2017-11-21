//
//  SettingItem.swift
//  
//
//  Created by D on 15/6/29.
//
//

import UIKit

class SettingItem: NSObject {
    var _name:String = ""
    var _value:AnyObject = "未设置"
    var _choices:[String]!
    
    init(name: String, choices: [String]!) {
        super.init()
        _name = name
        _choices = choices
    }
}
