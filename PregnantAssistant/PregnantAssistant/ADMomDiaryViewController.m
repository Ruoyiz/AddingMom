//
//  ADMomDiaryViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADMomDiaryViewController.h"
#import "ADMomEditNoteViewController.h"
#import "ADNoteCell.h"
#import "ADDiaryHeaderView.h"
#import "ADNotePreviewView.h"

#define LINESPACE 8
#define ADDBTNHEIGHT 52

@interface ADMomDiaryViewController ()

@end

@implementation ADMomDiaryViewController

-(void)dealloc
{
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTitle = @"孕妈日记";
    
    [self showSyncAlert];

    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    [ADNoteDAO updateDataBaseOnfinish:^{
        [ADNoteDAO uploadOldData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addNoteBtn];

    [self loadTableView];
    
    [self syncAllDataOnFinish:nil];
}

- (void)back
{
    [ADNoteDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];

    [self.navigationController popViewControllerAnimated:YES];
}
     
- (void)reloadData
{
    self.allNoteArray = [ADNoteDAO readAllData];
    
    NSLog(@"ALL NOTE:%@", self.allNoteArray);
    if (self.myTableView == nil) {
        [self addNoteTableView];
        [self addLine];
    }
    if (_tipLabel == nil) {
        [self addEmptyView];
    }
    
    if (self.allNoteArray.count == 0) {
        self.myTableView.hidden = YES;
        self.lineView.hidden = YES;
        
        self.tipLabel.hidden = NO;
        self.tipImage.hidden = NO;
        self.emptyBgView.hidden = NO;
    } else {
        self.myTableView.hidden = NO;
        self.lineView.hidden = NO;
        
        self.tipLabel.hidden = YES;
        self.tipImage.hidden = YES;
        self.emptyBgView.hidden = YES;
        [self.myTableView reloadData];
    }
}

- (void)addEmptyView
{
    if (_tipLabel.superview == nil) {
        NSString *aTip =
        @"十月怀胎,与宝宝合体的日子,既让准妈妈辛苦,又十分幸福。把孕期的酸甜苦辣,喜怒哀乐都记下来吧~";
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 2, SCREEN_WIDTH -28, 64)];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aTip];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
        
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, [aTip length])];
        _tipLabel.attributedText = attributedString;
        
        _tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel.numberOfLines = 2;
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor font_Brown];
        
        [self.view addSubview:_tipLabel];
        
        _tipImage =
        [[UIImageView alloc]initWithFrame:
         CGRectMake((SCREEN_WIDTH -210)/2, SCREEN_HEIGHT -156/3 -56, 210, 156/3)];
        _tipImage.image = [UIImage imageNamed:@"点击开始记录"];
        
        [self.view addSubview:_tipImage];
        [self.view bringSubviewToFront:_tipImage];
    }

    [self addEmptyIconView];
}

- (void)addEmptyIconView
{
    if (_emptyBgView.superview == nil) {
        _emptyBgView =
        [[ADShadowBgView alloc]initWithFrame:CGRectMake(12, 64, SCREEN_WIDTH -28, SCREEN_HEIGHT - 184)];
        
        UIImage *emptyImage = [UIImage imageNamed:@"暂无记录绿色"];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -105)/2 -12, 42, 105, 161)];
        imgView.image = emptyImage;
        
        [_emptyBgView addSubview:imgView];
        
        [self.view addSubview:_emptyBgView];
    }
}

- (void)addNoteBtn
{
    if (_addNote.superview == nil) {
        self.addNote = [[ADAddBottomBtn alloc]initWithFrame:
                        CGRectMake(0, SCREEN_HEIGHT -ADDBTNHEIGHT, SCREEN_WIDTH, ADDBTNHEIGHT)];
        
        [self.addNote addTarget:self action:@selector(pushAddNoteVc) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.addNote];
        [self.view bringSubviewToFront:self.addNote];
    }
}

- (void)addNoteTableView
{
    if (self.myTableView.superview == nil) {
//        int naviHeight = [ADHelper getNavigationBarHeight];
    
        self.myTableView =
        [[ADDiaryTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - ADDBTNHEIGHT - 64)];
        
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
        [self.myTableView registerNib:[UINib nibWithNibName:@"ADNoteCell" bundle:[NSBundle mainBundle]]
               forCellReuseIdentifier:@"aNoteCell"];
        
        self.myTableView.backgroundColor = [UIColor bg_lightYellow];
        self.myTableView.separatorColor = [UIColor clearColor];
        
        [self.view addSubview:self.myTableView];
    }
}

- (void)addLine
{
    if (_lineView.superview == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 1.5, SCREEN_HEIGHT)];
        _lineView.backgroundColor = [UIColor btn_green_bgColor];
        [self.view addSubview:_lineView];
    }
}

- (void)loadTableView
{
    self.allNoteArray = [ADNoteDAO readAllData];
    
    NSLog(@"ALL NOTE:%@", self.allNoteArray);
    if (self.myTableView == nil) {
        [self addNoteTableView];
        [self addLine];
    }
    if (_tipLabel == nil) {
        [self addEmptyView];
    }
    
    if (self.allNoteArray.count == 0) {
        self.myTableView.hidden = YES;
        self.lineView.hidden = YES;
        
        self.tipLabel.hidden = NO;
        self.tipImage.hidden = NO;
        self.emptyBgView.hidden = NO;
    } else {
        self.myTableView.hidden = NO;
        self.lineView.hidden = NO;
        
        self.tipLabel.hidden = YES;
        self.tipImage.hidden = YES;
        self.emptyBgView.hidden = YES;
    }
    
    [self.myTableView reloadData];
}

- (void)pushAddNoteVc
{
    ADMomEditNoteViewController *aMomNoteVc = [[ADMomEditNoteViewController alloc]init];
    [self.navigationController pushViewController:aMomNoteVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allNoteArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADNewNote *aNote = _allNoteArray[indexPath.section];
    NSString *aNoteStr = aNote.note;

    CGSize sizeHeight = [aNoteStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 68)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13+4]}
                                               context:nil].size;
    
    int height = sizeHeight.height +32;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdStr = @"aNoteCell";
    
    ADNoteCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    aCell.backgroundColor = [UIColor bg_lightYellow];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(ADNoteCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set Data
    ADNewNote *aNote = _allNoteArray[indexPath.section];
    
    cell.aNoteStr = aNote.note;
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    ADDiaryHeaderView *aHeaderView =
    [[ADDiaryHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    aHeaderView.backgroundColor = [UIColor bg_lightYellow];
    
    ADNewNote *aNote = _allNoteArray[section];
    aHeaderView.titleLabel.text = [ADHelper getCellTitleWithDate:aNote.publishDate];
    return aHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADMomEditNoteViewController *aMomNoteVc = [[ADMomEditNoteViewController alloc]init];
    aMomNoteVc.noteIndex = indexPath.section;
    aMomNoteVc.isEditHaveNote = YES;
    [self.navigationController pushViewController:aMomNoteVc animated:YES];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADNoteDAO syncAllDataOnGetData:^(NSError *error) {
//        [self reloadData];
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        if (error != nil) {
            NSLog(@"err:%@", error);
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        } else {
            [self stopRotateSyncBtn];
        }
    }];
}

@end