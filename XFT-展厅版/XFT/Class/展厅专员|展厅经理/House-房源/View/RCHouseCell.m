//
//  RCHouseCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseCell.h"
#import "RCHouseList.h"

@interface RCHouseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tags;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@end
@implementation RCHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /** 账号角色 1:展厅管理经理 2:展厅顾问专员 3:展厅小蜜蜂 */
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2){
        self.reportBtn.hidden = NO;
    }else{
        self.reportBtn.hidden = YES;
    }
}
-(void)setHouse:(RCHouseList *)house
{
    _house = house;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:_house.headPic]];
    self.name.text = _house.name;
    self.price.text = [NSString stringWithFormat:@"均价%@元/m²",_house.price];
    self.areaName.text = [NSString stringWithFormat:@"%@ %@",_house.huXingName,_house.areaInterval];
    if (_house.tag && _house.tag.length) {
        NSArray *tagNames = [_house.tag componentsSeparatedByString:@","];
        for (int i=0; i<self.tags.count; i++) {
            UILabel *tagL = self.tags[i];
            if ((tagNames.count-1) >= i) {
                tagL.hidden = NO;
                tagL.text = [NSString stringWithFormat:@" %@ ",tagNames[i]];
            }else{
                tagL.hidden = YES;
            }
        }
    }else{
        for (UILabel *tagL in self.tags) {
            tagL.hidden = YES;
        }
    }
}
- (IBAction)reportClicked:(UIButton *)sender {
    if (self.reportCall) {
        self.reportCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
