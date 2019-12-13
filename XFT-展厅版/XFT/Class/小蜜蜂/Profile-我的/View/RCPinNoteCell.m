//
//  RCPinNoteCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPinNoteCell.h"
#import "RCTaskPin.h"

@interface RCPinNoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end
@implementation RCPinNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPin:(RCTaskPin *)pin
{
    _pin = pin;
    self.type.text = [_pin.type isEqualToString:@"1"]?@"外勤签到":@"任务签到";
    self.time.text = _pin.createDate;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:_pin.photo]];
}
-(void)setPin1:(RCTaskPin *)pin1
{
    _pin1 = pin1;
    self.type.text = _pin1.name;
    self.time.text = _pin1.createTime;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:_pin1.photo]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
