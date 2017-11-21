//
//  ADCollectSearchBar.swift
//  
//
//  Created by D on 15/6/25.
//
//

import UIKit

class ADCollectSearchBar: UISearchBar {

    override func layoutSubviews() {
        
        var searchField:UITextField!
        searchField = subviews[0].subviews.last as! UITextField
        
        if searchField.isKindOfClass(NSClassFromString("UITextField")) && searchField != nil {
            searchField.borderStyle = UITextBorderStyle.RoundedRect
            searchField.layer.cornerRadius = 8.0;
            searchField.layer.masksToBounds = true;
            searchField.layer.borderColor = UIColor.cell_placeHolder_image_color().CGColor
            searchField.layer.borderWidth = 1.0;
        }

        super.layoutSubviews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        for view in subviews {
            // for before iOS7.0
            if view.isKindOfClass(NSClassFromString("UISearchBarBackground")) {
                view.removeFromSuperview()
                break;
            }
            
            // for later iOS7.0(include)
            if view.isKindOfClass(NSClassFromString("UIView")) && view.subviews.count > 0 {
                view.subviews[0].removeFromSuperview()
//                var targetView = view.subviews[0] as! UIView
//                targetView.backgroundColor = UIColor.whiteColor()
                break;
            }
        }
    }
}
