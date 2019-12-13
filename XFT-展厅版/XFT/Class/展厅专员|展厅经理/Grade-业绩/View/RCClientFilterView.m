//
//  RCClientFilterView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientFilterView.h"
#import "RCSearchTagCell.h"
#import "RCSearchTagHeader.h"
#import "RCClientFilterTimeView.h"
#import <ZLCollectionViewVerticalLayout.h>
#import <zhPopupController.h>
#import "WSDatePickerView.h"
#import "RCShowRoomFilter.h"
#import "RCShowRoomProject.h"
#import "RCClientFilter.h"

static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";
static NSString *const ClientFilterTimeView = @"ClientFilterTimeView";

@interface RCClientFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) UITextField *reportBeginTime;
@property (weak, nonatomic) UITextField *reportEndTime;
@property (weak, nonatomic) UITextField *visitBeginTime;
@property (weak, nonatomic) UITextField *visitEndTime;
//是否显示
@property (nonatomic, assign) BOOL show;
/* 客户等级 */
@property(nonatomic,strong) NSArray *cusLevels;
@end
@implementation RCClientFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cusLevels = @[@"A",@"B",@"C",@"D"];
    
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientFilterTimeView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ClientFilterTimeView];
}
-(void)setFilterData:(RCClientFilter *)filterData
{
    _filterData = filterData;
    [self.collectionView reloadData];
}
-(void)setFilterModel:(RCShowRoomFilter *)filterModel
{
    _filterModel = filterModel;
    
    // 初始化选中
    for (RCShowRoomProject *pro in _filterModel.projects) {
        if (pro.isSelected) {
            _filterModel.selectPro = pro;
            break;
        }
    }
    [self.collectionView reloadData];
}

- (IBAction)resetClicked:(UIButton *)sender {
    // 清空时间
    self.reportBeginTime.text = nil;
    self.reportEndTime.text = nil;
    self.visitBeginTime.text = nil;
    self.visitEndTime.text = nil;
    
    if (self.filterData) {
        self.filterData.reportStartStr = @"";
        self.filterData.reportEndStr = @"";
        
        self.filterData.reportStart = 0;
        self.filterData.reportEnd = 0;

        // 清空选择
        self.filterData.selectPro.isSelected = NO;
        RCFilterPro *pro = self.filterData.proList.firstObject;
        pro.isSelected = YES;
        self.filterData.selectPro = pro;
        
        self.filterData.selectAgent.isSelected = NO;
        RCFilterAgent *agent = self.filterData.agentList.firstObject;
        agent.isSelected = YES;
        self.filterData.selectAgent = agent;
        
    }else{
        self.filterModel.reportStartStr = @"";
        self.filterModel.reportEndStr = @"";
        self.filterModel.visitStartStr = @"";
        self.filterModel.visitEndStr = @"";
        
        self.filterModel.reportStart = 0;
        self.filterModel.reportEnd = 0;
        self.filterModel.visitStart = 0;
        self.filterModel.visitEnd = 0;

        // 清空选择
        self.filterModel.cusLevel = @"";
        
        self.filterModel.selectPro.isSelected = NO;
        self.filterModel.selectPro = nil;
    }
    
    [self.collectionView reloadData];
}
- (IBAction)confirmClicked:(UIButton *)sender {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    if (self.filterData) {
        if ([self.reportBeginTime hasText]) {
            NSDate *date = [formatter dateFromString:self.reportBeginTime.text];
            self.filterData.reportStart = [date timeIntervalSince1970];
            self.filterData.reportStartStr = self.reportBeginTime.text;
        }else{
            self.filterModel.reportStart = 0;
            self.filterModel.reportStartStr = @"";
        }
        
        if ([self.reportEndTime hasText]) {
            NSDate *date = [formatter dateFromString:self.reportEndTime.text];
            self.filterData.reportEnd = [date timeIntervalSince1970];
            self.filterData.reportEndStr = self.reportEndTime.text;
        }else{
            self.filterData.reportEnd = 0;
            self.filterData.reportEndStr = @"";
        }
        
        if ([self.delegate respondsToSelector:@selector(filterDidConfirm:selectProId:selectAgentId:reportBeginTime:reportEndTime:)]) {
            [self.delegate filterDidConfirm:self selectProId:self.filterData.selectPro.proUuid selectAgentId:self.filterData.selectAgent.uuid reportBeginTime:self.filterData.reportStart reportEndTime:self.filterData.reportEnd];
        }
    }else{
        if ([self.reportBeginTime hasText]) {
            NSDate *date = [formatter dateFromString:self.reportBeginTime.text];
            self.filterModel.reportStart = [date timeIntervalSince1970];
            self.filterModel.reportStartStr = self.reportBeginTime.text;
        }else{
            self.filterModel.reportStart = 0;
            self.filterModel.reportStartStr = @"";
        }
        
        if ([self.reportEndTime hasText]) {
            NSDate *date = [formatter dateFromString:self.reportEndTime.text];
            self.filterModel.reportEnd = [date timeIntervalSince1970];
            self.filterModel.reportEndStr = self.reportEndTime.text;
        }else{
            self.filterModel.reportEnd = 0;
            self.filterModel.reportEndStr = @"";
        }
        
        if ([self.visitBeginTime hasText]) {
            NSDate *date = [formatter dateFromString:self.visitBeginTime.text];
            self.filterModel.visitStart = [date timeIntervalSince1970];
            self.filterModel.visitStartStr = self.visitBeginTime.text;
        }else{
            self.filterModel.visitStart = 0;
            self.filterModel.visitStartStr = @"";
        }
        
        if ([self.visitEndTime hasText]) {
            NSDate *date = [formatter dateFromString:self.visitEndTime.text];
            self.filterModel.visitEnd = [date timeIntervalSince1970];
            self.filterModel.visitEndStr = self.visitEndTime.text;
        }else{
            self.filterModel.visitEnd = 0;
            self.filterModel.visitEndStr = @"";
        }
        
        
        if ([self.delegate respondsToSelector:@selector(filterDidConfirm:cusLevel:selectProId:reportBeginTime:reportEndTime:visitBeginTime:visitEndTime:)]) {
            [self.delegate filterDidConfirm:self cusLevel:@"" selectProId:self.filterModel.selectPro.uuid reportBeginTime:self.filterModel.reportStart reportEndTime:self.filterModel.reportEnd visitBeginTime:self.filterModel.visitStart visitEndTime:self.filterModel.visitEnd];
        }
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.filterData) {
        return 2;
    }else{
        return 2;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.filterData) {
        if (section == 0) {
            return self.filterData.proList.count;
        }else{
            return self.filterData.agentList.count;
        }
    }else{
        if (section == 0) {
            return self.cusLevels.count;
        }else{
            return self.filterModel.projects.count;
        }
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    if (self.filterData) {
        if (indexPath.section == 0) {
            RCFilterPro *pro = self.filterData.proList[indexPath.item];

            cell.contentText.text = pro.proName;
            cell.contentText.backgroundColor = pro.isSelected?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = pro.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
        }else{
            RCFilterAgent *agent = self.filterData.agentList[indexPath.item];

            cell.contentText.text = agent.name;
            cell.contentText.backgroundColor = agent.isSelected?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = agent.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
        }
    }else{
        if (indexPath.section == 0) {
            NSString *cusLevel = self.cusLevels[indexPath.item];
            cell.contentText.text = cusLevel;
            cell.contentText.backgroundColor = [cusLevel isEqualToString:self.filterModel.cusLevel]?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = [cusLevel isEqualToString:self.filterModel.cusLevel]?[UIColor whiteColor]:[UIColor lightGrayColor];
        }else{
            RCShowRoomProject *pro = self.filterModel.projects[indexPath.item];
            cell.contentText.text = pro.name;
            cell.contentText.backgroundColor = pro.isSelected?HXControlBg:HXGlobalBg;
            cell.contentText.textColor = pro.isSelected?[UIColor whiteColor]:[UIColor lightGrayColor];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     if (self.filterData) {
        if (indexPath.section == 0) {
            self.filterData.selectPro.isSelected = NO;
            RCFilterPro *pro = self.filterData.proList[indexPath.item];
            pro.isSelected = YES;
            self.filterData.selectPro = pro;
            [collectionView reloadData];
        }else{
            self.filterData.selectAgent.isSelected = NO;
            RCFilterAgent *agent = self.filterData.agentList[indexPath.item];
            agent.isSelected = YES;
            self.filterData.selectAgent = agent;
            [collectionView reloadData];
        }
     }else{
         if (indexPath.section == 0) {
             NSString *cusLevel = self.cusLevels[indexPath.item];
             self.filterModel.cusLevel = cusLevel;
             [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
         }else{
             self.filterModel.selectPro.isSelected = NO;
             RCShowRoomProject *pro = self.filterModel.projects[indexPath.item];
             pro.isSelected = YES;
             self.filterModel.selectPro = pro;
             [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
         }
     }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        RCSearchTagHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        headerView.tabText.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        if (self.filterData) {
            if (indexPath.section == 0) {
                headerView.tabText.text = @"楼盘选择";
            }else{
                headerView.tabText.text = @"中介经纪人选择";
            }
        }else{
            if (indexPath.section == 0) {
                headerView.tabText.text = @"客户等级";
            }else{
                headerView.tabText.text = @"报备项目";
            }
        }
        headerView.locationBtn.hidden = YES;
        return headerView;
    }else if ([kind isEqualToString : UICollectionElementKindSectionFooter]){
        RCClientFilterTimeView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ClientFilterTimeView forIndexPath:indexPath];
        if (self.filterData) {
            footerView.visitTimeView.hidden = YES;
            footerView.reportBeginTime.text = self.filterData.reportStartStr;
            footerView.reportEndTime.text = self.filterData.reportEndStr;
            footerView.filterTimeCall = ^(UITextField * _Nonnull textField) {
                //年-月-日
                WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
                    
                    NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                    textField.text = dateString;
                }];
                datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
                datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
                datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
                [datepicker show];
            };
            if (indexPath.section == 1) {
                self.reportBeginTime = footerView.reportBeginTime;
                self.reportEndTime = footerView.reportEndTime;
                return footerView;
            }else{
                return nil;
            }
        }else{
            footerView.visitTimeView.hidden = [MSUserManager sharedInstance].curUserInfo.ulevel == 2 ? NO:YES;
            if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) {
                if (self.cusType == 0) {//已报备
                    footerView.visitTimeView.hidden = YES;
                }else{
                    footerView.visitTimeView.hidden = NO;
                }
            }else {
                footerView.visitTimeView.hidden = YES;
            }
            footerView.reportBeginTime.text = self.filterModel.reportStartStr;
            footerView.reportEndTime.text = self.filterModel.reportEndStr;
            footerView.visitBeginTime.text = self.filterModel.visitStartStr;
            footerView.visitEndTime.text = self.filterModel.visitEndStr;
            footerView.filterTimeCall = ^(UITextField * _Nonnull textField) {
                //年-月-日
                WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
                    
                    NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                    textField.text = dateString;
                }];
                datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
                datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
                datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
                [datepicker show];
            };
            if (indexPath.section == 1) {
                self.reportBeginTime = footerView.reportBeginTime;
                self.reportEndTime = footerView.reportEndTime;
                self.visitBeginTime = footerView.visitBeginTime;
                self.visitEndTime = footerView.visitEndTime;
                return footerView;
            }else{
                return nil;
            }
        }
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.filterData) {
            return  CGSizeMake(collectionView.frame.size.width, 100);
        }else{
            if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) {
                if (self.cusType == 0) {//已报备
                     return  CGSizeMake(collectionView.frame.size.width, 100);
                }else{
                     return  CGSizeMake(collectionView.frame.size.width, 200);
                }
            }else {
                return  CGSizeMake(collectionView.frame.size.width, 100);
            }
        }
    }else{
        return CGSizeZero;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.filterData) {
        if (indexPath.section == 0) {
            RCFilterPro *pro = self.filterData.proList[indexPath.item];
            return CGSizeMake([pro.proName boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
        }else{
            RCFilterAgent *agent = self.filterData.agentList[indexPath.item];
            return CGSizeMake([agent.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
        }
    }else{
        if (indexPath.section == 0) {
            return CGSizeMake([self.cusLevels[indexPath.item] boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
        }else{
            RCShowRoomProject *pro = self.filterModel.projects[indexPath.item];
            return CGSizeMake([pro.name boundingRectWithSize:CGSizeMake(1000000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 30);
        }
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 15, 5, 15);
}
@end
