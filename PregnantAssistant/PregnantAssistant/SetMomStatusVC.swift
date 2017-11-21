//
//  SetMomStatusVC.swift
//  
//
//  Created by D on 15/7/15.
//
//

import UIKit

typealias finishBlock = () -> ()

class SetMomStatusVC: ADBaseVC {
    let cellId = "setCellId"
    let loadingCellId = "loadingCell"
    let formTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight), style: .Grouped)
    var myPicker = CustomPicker(frame: CGRectMake(0, screenHeight, screenWidth, 256))
    var formData = [SettingItem(name: "孕育状态", choices: ["孕期", "育儿"])]
    var selectRow = 0
    var isGuiding = false
    var finishAction : finishBlock?
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTitle = "孕育状态"
        view.addSubview(formTableView)
        self.readData()

        formTableView.registerNib(UINib(nibName: "ADLoadingTableViewCell", bundle: nil),
            forCellReuseIdentifier: loadingCellId)
        formTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        formTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        formTableView.setContentOffset(CGPointMake(0, -64), animated: false)
        formTableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        formTableView.dataSource = self
        formTableView.delegate = self
        
        myPicker.delegate = self
        
        if isGuiding {
            let rightBtn = UIButton(frame: CGRectMake(0, 0, 38, 40))
            
            rightBtn.setTitle("完成", forState: UIControlState.Normal)
            rightBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
            rightBtn.setTitleColor(UIColor.unEnable_btn_color(), forState: UIControlState.Disabled)
            rightBtn.setTitleColor(UIColor.btn_green_bgColor(), forState: UIControlState.Normal)
            rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            rightBtn.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
            navigationItem.rightBarButtonItem?.enabled = false
        }
        
        self.setBlackBack()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.readData()
        self.checkFormData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        myPicker.hide(false)
    }
    
    func readData() {
        println("token: \(NSUserDefaults.standardUserDefaults().addingToken)")
        if count(NSUserDefaults.standardUserDefaults().addingToken) > 0 {

//            if isGuiding == false {
                self.buildFormData()
                self.formTableView.reloadData()
                self.isLoading = false
//                self.checkFormData()
//            }
            
//            ADUserInfoSaveHelper.syncAllDataOnGetData(nil, onUploadProcess: nil, onUpdateFinish: { (err) -> Void in
//                self.isLoading = false
//                
//                self.buildFormData()
//                self.formTableView.reloadData()

//            })
        } else {
            self.isLoading = false
            self.buildFormData()
        }
    }
    
    func buildFormData() {
        var userInfoDic = ADUserInfoSaveHelper.readBasicUserInfo()
        println("userInfoDic: \(userInfoDic)")
        
        if userInfoDic == nil {
            // 弹起 uitableview 孕育状态
            var selectItem = formData[0]
            selectRow = 0
            myPicker.tip = "请选择\(selectItem._name)"
            myPicker.myPickerType = pickerType.select
            myPicker.selectValue = selectItem._value
            myPicker._dataSource = selectItem._choices
            myPicker.toSelectRow = 1
            myPicker.showInView(self.view)
            
            return
        }
        
        //build formData
        let userStatus = userInfoDic[userStatusKey] as? String
        formData = [SettingItem(name: "孕育状态", choices: ["孕期", "育儿"])]
        var userStatusItem = formData[0]
        
        if userStatus == "1" {
            userStatusItem._value = "孕期"
            formData.append(SettingItem(name: "预产期", choices: []))
            var secondItem = formData[1]
            secondItem._value = userInfoDic[userDueDateKey]!
        } else {
            userStatusItem._value = "育儿"
            
            formData.append(SettingItem(name: "宝宝生日", choices: []))
            formData.append(SettingItem(name: "宝宝性别", choices: ["男", "女"]))
            
            var secondItem = formData[1]
            var thirdItem = formData[2]
            secondItem._value = userInfoDic[babyBirthDayKey]!
            if userInfoDic[babySexKey] as! String == "1" {
                thirdItem._value = "男"
            } else {
                thirdItem._value = "女"
            }
        }
    }
    
    func checkFormData() {
        var fillAll = true
        for aItem in formData {
            if aItem._value is String && aItem._value as! String == "未设置" {
                fillAll = false
                break
            }
        }
        
        if fillAll {
            navigationItem.rightBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    override func back() {
        if isGuiding == false {
            self.done()
            
            NSNotificationCenter.defaultCenter().postNotificationName(updateRecommadListNotification,
                object: nil, userInfo: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func done() {
        //sync user Info
        var userInfo = [String: String]()
        for aItem in formData {
            //            println("value:\(aItem._value) name:\(aItem._name)")
            //未完成设置 警告
            if aItem._value is String {
                if aItem._value as! String == "未设置" {
                    UIAlertView(title: "未填写全部信息", message: "", delegate: self, cancelButtonTitle: "好的").show()
                    return
                }
            }
            switch aItem._name {
            case "孕育状态":
                if aItem._value as? String == "育儿" {
                    userInfo[userStatusKey] = "2"
                } else {
                    userInfo[userStatusKey] = "1"
                }
            case "预产期":
                var timeSp = Int(aItem._value.timeIntervalSince1970)
                println("time: \(timeSp)")
                userInfo[userDueDateKey] = "\(timeSp)"
            case "宝宝生日":
                var timeSp = Int(aItem._value.timeIntervalSince1970)
                userInfo[babyBirthDayKey] = "\(timeSp)"
            case "宝宝性别":
                if aItem._value as? String == "男" {
                    userInfo[babySexKey] = "1"
                } else {
                    userInfo[babySexKey] = "2"
                }
            default:
                "do nothing"
            }
        }
        println("dic: \(userInfo)")
        
        if isGuiding {
            ADToastHelp.showSVProgressToastWithTitle("请稍候")
        }
        
        ADUserInfoSaveHelper.saveBasicUserInfo(userInfo)

        NSUserDefaults.standardUserDefaults().firstLauch = false
        ADUserInfoSaveHelper.syncAllDataOnGetData(nil, onUploadProcess: nil, onUpdateFinish: nil)
        
        self.finishAction?()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        myPicker.hide(true)
    }
}

extension SetMomStatusVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1;
        }
        return formData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(loadingCellId) as! ADLoadingTableViewCell
            return cell
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        
        self.configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) -> Void {
        var entity = formData[indexPath.row]
        cell.textLabel?.text = entity._name
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        cell.selectionStyle = .None
        
        if entity._value is String {
            cell.detailTextLabel?.text = entity._value as? String
        } else {
            let date = entity._value as! NSDate
            cell.detailTextLabel?.text = date.toString(format: .Custom("yyyy-MM-dd"))
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension SetMomStatusVC: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //show Picker
        var selectItem = formData[indexPath.row]
        selectRow = indexPath.row
        myPicker.tip = "请选择\(selectItem._name)"
        if indexPath.row == 0 {
            myPicker.myPickerType = pickerType.select
            myPicker._dataSource = selectItem._choices
            myPicker.selectValue = selectItem._value
            
            if selectItem._value as! String == "孕期" {
                myPicker.toSelectRow = 0
            } else {
                myPicker.toSelectRow = 1
            }
            myPicker.showInView(self.view)
        } else {
            myPicker._dataSource = selectItem._choices
            
            if selectItem._name == "预产期" || selectItem._name == "宝宝生日" {
                myPicker.myPickerType = pickerType.date
                if selectItem._name == "预产期" {
                    myPicker.datePicker.maximumDate =
                        NSDate().dateByAddingTimeInterval(60*60*24*279)
                    myPicker.datePicker.minimumDate = NSDate()
                } else {
                    myPicker.datePicker.maximumDate = NSDate()
                    myPicker.datePicker.minimumDate =
                        NSDate().dateByAddingTimeInterval(-60*60*24*365*50)
                }
                
                if selectItem._value is NSDate {
                    println("picker\(myPicker.datePicker)")
                    myPicker.datePicker.date = selectItem._value as! NSDate
                } else {
                    myPicker.datePicker.date = NSDate()
                }
            } else {
                if selectItem._name == "宝宝性别" {
                    println("sex: \(selectItem._value)")
                    if selectItem._value as! String == "男" {
                        myPicker.toSelectRow = 0
                    } else {
                        myPicker.toSelectRow = 1
                    }
                }
                
                myPicker.myPickerType = pickerType.select
            }
            
            myPicker.showInView(self.view)
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var aItem = formData[0]
        if aItem._value is String && aItem._value as! String == "孕期" {
            let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
            
            let btn = UIButton(frame: CGRectMake(screenWidth - 116, 0, 116, 40))
            btn.setTitle("帮我计算预产期", forState: .Normal)
            
            btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            btn.addTarget(self, action: "changeToHelpCalc", forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView.addSubview(btn)
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func changeToHelpCalc() {
        myPicker._dataSource = []
        myPicker.tip = "请选择末次月经时间"
        myPicker.myPickerType = pickerType.date
        selectRow = 99
        myPicker.datePicker.maximumDate = NSDate()
        myPicker.datePicker.minimumDate = NSDate().dateByAddingDays(-279)
        println("sddddate:\(NSDate())")
        myPicker.showInView(self.view)
    }
}

extension SetMomStatusVC: customPickerDelegate {
    func didFinishSelect(res: AnyObject) {
        print("res: \(res)")
        //chage value
        var selectDate:NSDate!
        var aItem:SettingItem!
        if selectRow == 99 {
            aItem = formData[1]
            if res is NSDate {
                selectDate = res as! NSDate
                let finnalDate = selectDate.dateByAddingTimeInterval(279*60*60*24)
                
                aItem._value = finnalDate
            }
        } else {
            aItem = formData[selectRow]
            
            if res is String {
                aItem._value = res as! String
            } else if res is NSDate {
                selectDate = res as! NSDate
                aItem._value = selectDate
            }
        }
        
        if selectRow == 0 {
            if formData.count > 1 {
                formData.removeRange(Range(start: 1, end: formData.count))
            }
            
            if aItem._value as! String == "孕期" {
                formData.append(SettingItem(name: "预产期", choices: []))
            } else {
                formData.append(SettingItem(name: "宝宝生日", choices: []))
                formData.append(SettingItem(name: "宝宝性别", choices: ["男", "女"]))
            }
        }
        
        formTableView.reloadData()
        
        // set naviItem
        self.checkFormData()
    }
}