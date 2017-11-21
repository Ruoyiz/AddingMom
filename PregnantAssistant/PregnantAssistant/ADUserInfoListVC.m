//
//  ADUserInfoListVC.m
//  PregnantAssistant
//
//  Created by yitu on 15/3/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserInfoListVC.h"
#import "ADInfoListTextCell.h"
#import "ADInfoListImageCell.h"
#import "ADSetAgeViewController.h"
#import "ADWeightViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Utilities.h"
#import "ADMomSecretViewController.h"
#import "ADUserInfoSaveHelper.h"
#import "ADToastHelp.h"
#import "ADUserSyncMetaHelper.h"
#import "PregnantAssistant-Swift.h"
#import "ADMomLookContentDetailVC.h"
#import "ADSettingViewController.h"
#import "ADSetNIcknameViewController.h"
#import "ADPhotoActionSheet.h"
#import "UIImage+ADHandleImage.h"

@interface ADUserInfoListVC ()<photoActionSheetClickedDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    ADPhotoActionSheet *_photoActionSheet;
    ADInfoListImageCell *_cellIcon;
}
@end


@implementation ADUserInfoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length > 0) {
        [self setupViews];
    } else {
        [self addLoginBtnIsSecert:_fromMonSecret];
    }
    [self configNavigationView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
    [self configNavigationView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshIconImage)
                                                 name:finishDownloadImgNotification
                                               object:nil];
    
    [ADUserInfoSaveHelper syncAllDataOnGetData:^(NSError *error) {
    } onUploadProcess:^(NSError *error) {
    } onUpdateFinish:^(NSError *error) {
        [self refreshData];
    }];
}

- (void)setupViews
{
    self.settingNameArray = @[@"头像", @"昵称", @"年龄", @"身高", @"孕前体重", @"地区"];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIBAT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAT_HEIGHT)
                                                   style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
}

- (void)refreshData
{
    //NSLog(@"refresh once");
    NSString *tStr = [[NSUserDefaults standardUserDefaults] addingToken];
    if (tStr.length > 0) {
        //取本地
        NSString *nick = [ADUserInfoSaveHelper readUserName];
//        NSLog(@"read height:%@ w: %@",[ADUserInfoSaveHelper readUserHeight],[ADUserInfoSaveHelper readUserWeight]);
        NSString *height = [ADUserInfoSaveHelper readUserHeight];
        NSString *weight = [ADUserInfoSaveHelper readUserWeight];
        NSString *area = [ADUserInfoSaveHelper readUserArea];
        NSString *birthDayTpStr = [ADUserInfoSaveHelper readBirthDay];
        
        self.contentArray = @[@"", nick, birthDayTpStr, height, weight, area];
        [self.myTableView reloadData];

        NSLog(@"content array:%@", self.contentArray);
    }
}

- (void)configNavigationView
{
    if ([[NSUserDefaults standardUserDefaults]addingToken].length > 0) {
        self.myTitle = @"个人信息";
    } else {
        self.myTitle = @"登录";
    }
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN:10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0 ? 76:44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==1 ? _settingNameArray.count - 1:1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (void)refreshIconImage{
    _cellIcon.iconImage.image = [ADUserInfoSaveHelper readIconData];
    
    NSLog(@"img:%@ url:%@", _cellIcon.iconImage.image, _resDic[@"face"]);
    if (_cellIcon.iconImage.image == nil) {
        [_cellIcon.iconImage sd_setImageWithURL:[NSURL URLWithString:_resDic[@"face"]]
                              placeholderImage:[UIImage imageNamed:@""]
                                       options:SDWebImageProgressiveDownload];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierIndicate = @"CellIndicate";
    ADInfoListTextCell *cellIndicate = [tableView dequeueReusableCellWithIdentifier:CellIdentifierIndicate];
    
    static NSString *CellIconIdentifierIndicate = @"CellIcon";
    _cellIcon = [tableView dequeueReusableCellWithIdentifier:CellIconIdentifierIndicate];
    
    if (indexPath.section == 0) {
        if (_cellIcon == nil ) {
            _cellIcon = [[ADInfoListImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIconIdentifierIndicate];
            _cellIcon.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        _cellIcon.titleLabel.text = self.settingNameArray[indexPath.section];
        [self refreshIconImage];
        return _cellIcon;
    } else if (indexPath.section == 2) {
        UITableViewCell *aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:@"logout"];
        UILabel *LogoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH -24, 44)];
        LogoutLabel.text = @"退出登录";
        LogoutLabel.font = [UIFont systemFontOfSize:15];
        LogoutLabel.textColor = [UIColor btn_green_bgColor];
        LogoutLabel.textAlignment = NSTextAlignmentCenter;
        [aCell addSubview:LogoutLabel];
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return aCell;
    } else {
        if (cellIndicate == nil ) {
            cellIndicate = [[ADInfoListTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:CellIdentifierIndicate];
            cellIndicate.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellIndicate.titleLabel.text = self.settingNameArray[indexPath.row +1];
        
        NSString *string = _contentArray[indexPath.row +1];
        NSDate *mydate = [NSDate dateWithTimeIntervalSince1970:string.integerValue];
        switch (indexPath.row) {
            case 0:
                cellIndicate.contentLabel.text = _contentArray[indexPath.row +1];
                break;
            case 1:
                cellIndicate.contentLabel.text = [NSString stringWithFormat:@"%ld岁", (long)[ADHelper getAgeWithBirthDate: mydate]];
                break;
            case 2:
                cellIndicate.contentLabel.text = [NSString stringWithFormat:@"%@ cm",self.contentArray[indexPath.row +1]];
                break;
            case 3:
                cellIndicate.contentLabel.text = [NSString stringWithFormat:@"%@ kg",self.contentArray[indexPath.row +1]];
                break;
            case 4:
                cellIndicate.contentLabel.text =_contentArray[indexPath.row +1];
                break;
            default:
                break;
        }
        
        if ([_contentArray[indexPath.row + 1] isEqualToString:@"0"] || [_contentArray[indexPath.row + 1] isEqualToString:@""]) {
            cellIndicate.contentLabel.text = @"未设置";
        }

        return cellIndicate;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
//            [self addPhotoActionsheet];
            break;
        case 1:
            [self jumpSectionOneVCWithIndexpathRow:indexPath.row + 1];
            break;
        case 2:
            [self logoutAccount];
            break;
        default:
            break;
    }
}

- (void)addPhotoActionsheet{
    _photoActionSheet = [[ADPhotoActionSheet alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 160, SCREEN_WIDTH, 160) titleArray:@[@[@"拍照",@"重手机相册选择"],@[@"取消"]]];
    _photoActionSheet.deletege = self;
    [_photoActionSheet show];
}

- (void)jumpSectionOneVCWithIndexpathRow:(NSInteger)row{
    switch (row) {
        case 1: {
            ADSetNIcknameViewController *aVc = [[ADSetNIcknameViewController alloc]init];
            aVc.isNickNameVC = YES;
            aVc.nickName = _contentArray[row];
            [self.navigationController pushViewController: aVc animated:YES];
            break;
        }
        case 2: {
            ADSetAgeViewController *aVc = [[ADSetAgeViewController alloc]init];
            aVc.birthDayTimpSp = _contentArray[row];
            [self.navigationController pushViewController:aVc animated:YES];
            break;
        }
        case 3: {
            ADWeightViewController *aVc = [[ADWeightViewController alloc]init];
            aVc.heightStr = _contentArray[row];
            aVc.isWeight = NO;
            [self.navigationController pushViewController:aVc animated:YES];
            break;
        }
        case 4: {
            ADWeightViewController *aVc = [[ADWeightViewController alloc]init];
            aVc.weightStr = _contentArray[row];
            aVc.isWeight = YES;
            [self.navigationController pushViewController:aVc animated:YES];
            break;
        }
        case 5: {
            ADSetNIcknameViewController *aVc = [[ADSetNIcknameViewController alloc]init];
            aVc.isNickNameVC = NO;
            aVc.area = _contentArray[row];
            [self.navigationController pushViewController:aVc animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)logoutAccount
{
    ADLogoutAlertView *alertView = [[ADLogoutAlertView alloc] initWithLogoutType:ADLogoutTypeSynchronized];
//    if (haveUnsync) {
//        alertView = [[ADLogoutAlertView alloc] initWithLogoutType:ADLogoutTypeSyncing];
//    } else {
//        alertView = [[ADLogoutAlertView alloc] initWithLogoutType:ADLogoutTypeSynchronized];
//    }
    [alertView showWithConfirm:^{
        NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count >= 2) {
            UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count - 2];
            if([vc isKindOfClass:[ADSettingViewController class]]){
                ADSettingViewController *svc = (ADSettingViewController *)vc;
                [svc logout];
            }
        }
        
        [[ADNAccountCenter defaultCenter]exitAccount];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
//    [ADUserSyncMetaHelper isHaveUnSyncDataOnFinish:^(BOOL haveUnsync) {
//        ADLogoutAlertView *alertView = nil;
//        if (haveUnsync) {
//            alertView = [[ADLogoutAlertView alloc] initWithLogoutType:ADLogoutTypeSyncing];
//        } else {
//            alertView = [[ADLogoutAlertView alloc] initWithLogoutType:ADLogoutTypeSynchronized];
//        }
//        [alertView showWithConfirm:^{
//            NSArray *viewControllers = self.navigationController.viewControllers;
//            if (viewControllers.count >= 2) {
//                UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count - 2];
//                if([vc isKindOfClass:[ADSettingViewController class]]){
//                    ADSettingViewController *svc = (ADSettingViewController *)vc;
//                    [svc logout];
//                }
//            }
//            
//            [[ADNAccountCenter defaultCenter]exitAccount];
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }];
}

#pragma mark - photoActionSheetDelegate
- (void)photoActionSheetClicked:(ADPhotoActionSheet *)photoActionSheet atIndex:(NSInteger)index{
    if (index == 0) {
        [self takePhoto];
    }else if(index == 1){
        [self takePhotographAlbum];
    }
}

- (void)takePhoto{
    UIImagePickerControllerSourceType souchType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = souchType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [ADToastHelp showSVProgressToastWithError:@"打开相机失败"];
    }
}

- (void)takePhotographAlbum{
    UIImagePickerControllerSourceType souchType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = souchType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [ADToastHelp showSVProgressToastWithError:@"打开相册失败"];
    }
}

#pragma mark - weixin method
- (void)loginWechatAccount
{
//    [[ADAccountCenter sharedADAccountCenter] oAuthWeiXinWithTarget:self oauthType:ADLogin success:@selector(loginOAuthSuccessful:) failure:@selector(loginOAuthFailure:)];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image reSizeImageToSize:CGSizeMake(50, 50)];
        [ADUserInfoSaveHelper saveImageDataWithImage:image aName:[ADUserInfoSaveHelper readUserName]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginOAuthSuccessful:(NSString *)iconUrl
{
    [[NSNotificationCenter defaultCenter] postNotificationName:loginWeiSucessNotify object:nil];
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp updateBadgeNum];
    
    if (_fromMonSecret) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginOAuthFailure:(id)obj
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
