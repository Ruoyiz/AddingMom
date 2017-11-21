//
//  ADBaseLookTableViewCell.swift
//  
//
//  Created by D on 15/7/27.
//
//

import UIKit
import QuartzCore

protocol LookCellDelegate{
    func titleClicked(index:Int)
}

class ADBaseLookTableViewCell: UITableViewCell {
    
    var userImage: UIImageView!
    var userNameLabel: UILabel!
    var publishTimeLabel: UILabel!
    var contentImgView: UIImageView!
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    var minsReadLabel: UILabel!
    var readImgView: UIImageView!
    var radio:CGFloat = 0
    var edge:CGFloat = 20
    var coverButton : UIButton!
    var delegate :LookCellDelegate?
    
    var entity: ADMomContentInfo? {
        set {
            if let value = newValue {
                userNameLabel?.text = value.mediaSource
                publishTimeLabel?.text = ADHelper.getAmongTimeByTimeSp(value.aPublishTime)
                                
                titleLabel?.attributedText =
                    self.getAttributeString(24, lineHeightMultiple: 1.2, originString: value.title, fontColor: UIColor.cell_title_Color(), isBold: true)
                let height = self.heightForAttributedString(titleLabel.attributedText, maxWidth: screenWidth - edge * 2)

                if (value.aContentStyle.value == contentOnlyTextStyle.value) {
                    contentImgView.image = nil
                    contentImgView.frame = CGRectMake(0, 0, 0, 0)
                    titleLabel.frame = CGRectMake(edge, 58, screenWidth - edge * 2, height)
                } else if (value.aContentStyle.value == contentRightImageStyle.value) {
                    titleLabel.frame = CGRectMake(edge, 234, screenWidth - edge * 2, height)
                } else {
                    contentImgView.frame = CGRectMake(edge, 64, screenWidth - edge * 2, 158)
                    titleLabel.frame = CGRectMake(edge, 234, screenWidth - edge * 2, height)
                }

                contentLabel?.attributedText =
                    self.getAttributeString(14, lineHeightMultiple: 1.5, originString: value.aDescription, fontColor: UIColor.cell_content_Color(), isBold: false)
                
                var contentHeight:CGFloat = 0
                if contentLabel.attributedText.length > 0 {
                    contentHeight =
                    self.heightForAttributedString(contentLabel.attributedText, maxWidth: screenWidth - edge * 2)
                }
                contentLabel.frame = CGRectMake(edge, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5,
                                                screenWidth - edge * 2, contentHeight)

                minsReadLabel?.text = ADHelper.getMinsBySecond(value.timeCost)
                
                var bottomStartHeight:CGFloat = 0
                if contentLabel.attributedText.length > 0 {
                    bottomStartHeight = contentLabel.frame.origin.y + contentLabel.frame.size.height + 18
                } else {
                    bottomStartHeight = contentLabel.frame.origin.y + contentLabel.frame.size.height + 14
                }
                readImgView.frame = CGRectMake(edge, bottomStartHeight, 14, 14)
                minsReadLabel.frame = CGRectMake(edge + 22, bottomStartHeight, 130, 15)
                
                let cellHeight = minsReadLabel.frame.origin.y + minsReadLabel.frame.size.height + 20
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, screenWidth, cellHeight)
            } else {
                _entity = nil;
            }
        }
        
        get {
            return _entity!
        }
    }
    
    var _entity: ADMomContentInfo?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16)
        
        // top
        if screenWidth < 414 {
            edge = 16
        }
        
        userImage = UIImageView(frame: CGRectMake(edge, 16, 36, 36))
        userImage.backgroundColor = UIColor.grayColor()
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
        
        self.addSubview(userImage)
        
        let nameXPos = userImage.frame.origin.x + userImage.frame.size.width + 6
        userNameLabel = UILabel(frame: CGRectMake(nameXPos, 17, screenWidth - 20 - 64, 16))
        userNameLabel.font = UIFont.FZLTWithSize(14)
        userNameLabel.backgroundColor = UIColor.whiteColor()
        userNameLabel.opaque = false
        self.addSubview(userNameLabel)
        
        publishTimeLabel = UILabel(frame: CGRectMake(nameXPos + 14, 39, 154, 10))
        publishTimeLabel.font = UIFont.FZLTWithSize(9)
        publishTimeLabel.textColor = UIColor.momLookCell_subTxtColor()
        publishTimeLabel.backgroundColor = UIColor.whiteColor()
        publishTimeLabel.opaque = false
        self.addSubview(publishTimeLabel)
        
        let clockImgView = UIImageView(frame: CGRectMake(nameXPos, 40, 8, 8))
        clockImgView.image = UIImage(named: "clock-circular-outline")
//        clockImgView.backgroundColor = UIColor.whiteColor()
        clockImgView.opaque = false

        self.addSubview(clockImgView)
        
        // mid
        contentImgView = UIImageView(frame: CGRectMake(edge, 64, screenWidth - edge * 2, 158))
        contentImgView.backgroundColor = UIColor.grayColor()
        contentImgView.contentMode = UIViewContentMode.ScaleAspectFill
        contentImgView.clipsToBounds = true
        self.addSubview(contentImgView)
        
        titleLabel = UILabel()
//        titleLabel.backgroundColor = UIColor.whiteColor()
//        titleLabel.opaque = false
        titleLabel.numberOfLines = 10
        titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.addSubview(titleLabel)
        
        contentLabel = UILabel()
//        contentLabel.backgroundColor = UIColor.whiteColor()
//        contentLabel.opaque = false
        contentLabel.numberOfLines = 100
        contentLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.addSubview(contentLabel)

        // bottom
        minsReadLabel = UILabel()
        minsReadLabel.backgroundColor = UIColor.whiteColor()
        minsReadLabel.opaque = false

        minsReadLabel.textColor = UIColor.momLookCell_subTxtColor()
        minsReadLabel.font = UIFont.FZLTWithSize(13)
        self.addSubview(minsReadLabel)

        readImgView = UIImageView(frame: CGRectMake(0, 0, 14, 14))
        readImgView.image = UIImage(named: "read")
        self.addSubview(readImgView)
        
        coverButton = UIButton(frame: CGRectMake(edge, 16, screenWidth, 36))
        coverButton.addTarget(self, action:"buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside);
        self.addSubview(coverButton);
    }
    
    func heightForAttributedString(txt: NSAttributedString, maxWidth: CGFloat) -> CGFloat {
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading
        let size =
        txt.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: options, context: nil).size
        return size.height + 1
    }
    
    func getAttributeString(fontSize:CGFloat, lineHeightMultiple:CGFloat, originString: String, fontColor: UIColor, isBold: Bool) -> NSMutableAttributedString {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        var attrStr = NSMutableAttributedString(string: originString)
        attrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        if isBold {
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(fontSize), range: NSMakeRange(0, attrStr.length))
        } else {
            attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(fontSize), range: NSMakeRange(0, attrStr.length))
        }
        attrStr.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSMakeRange(0, attrStr.length))
        
        return attrStr
    }
    
    func buttonClicked(sender:UIButton)
    {
        self.delegate?.titleClicked(sender.tag)
    }
    
    func setImgWithUrlString(aUrlStr: String, type: momLookContentStyle) {
        
        contentImgView.sd_setImageWithURL(NSURL(string: aUrlStr), placeholderImage: nil, options: SDWebImageOptions.LowPriority, progress: { (receivedSize, exptSize) -> Void in
                self.contentImgView.alpha = 0
            }, completed: { (img, err, cacheType, imgUrl) -> Void in
//                println("entity :\(self.entity)")
//                if (self.entity?.aContentStyle.value == contentRightImageStyle.value) {
                if (type.value == contentRightImageStyle.value && img != nil) {
                    self.radio = img.size.width / img.size.height
                    
                    var width:CGFloat = 158 * self.radio
                    if width > screenWidth - self.edge*2 {
                       width = screenWidth - self.edge*2
                    }
                    
                    self.contentImgView.frame = CGRectMake(self.edge, 64, width, 158)
                } else {
//                    self.contentImgView.frame = CGRectMake(20, 64, screenWidth - 40, 158)
                }

                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.contentImgView.alpha = 1
                })
        })
    }

    func cancelDownLoadImg() {
        contentImgView.sd_cancelCurrentImageLoad()
        userImage.sd_cancelCurrentImageLoad()
    }
}