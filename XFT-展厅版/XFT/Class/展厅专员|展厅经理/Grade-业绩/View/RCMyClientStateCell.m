//
//  RCMyClientStateCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientStateCell.h"
#import "RCMaganerGrade.h"

@interface RCMyClientStateCell ()
@property (weak, nonatomic) IBOutlet UILabel *clientNum;
@property (weak, nonatomic) IBOutlet UILabel *clientState;
@property (weak, nonatomic) IBOutlet UILabel *clientType;

@end
@implementation RCMyClientStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGrade:(RCMaganerGrade *)grade
{
    _grade = grade;
    
    self.clientNum.text = [NSString stringWithFormat:@"%zd",_grade.totalNum];
    self.clientState.text = _grade.groupName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.clientNum.textColor = selected ? HXControlBg :  UIColorFromRGB(0x999999);
    self.clientState.textColor = selected ? HXControlBg :  UIColorFromRGB(0x999999);
    
    self.clientType.textColor = selected ? HXControlBg :  UIColorFromRGB(0x999999);
}

@end
