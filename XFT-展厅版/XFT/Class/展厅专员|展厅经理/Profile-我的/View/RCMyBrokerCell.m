//
//  RCMyBrokerCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerCell.h"
#import "RCMyBroker.h"

@interface RCMyBrokerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *type2;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *num;

@end
@implementation RCMyBrokerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBroker:(RCMyBroker *)broker
{
    _broker = broker;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_broker.headpic]];
    self.name.text = _broker.name;
    
    if ([_broker.isStaff isEqualToString:@"1"] && [_broker.isOwner isEqualToString:@"1"]) {
        self.type2.hidden = NO;
        self.type.text = @" 员工经纪人 ";
        self.type2.text = @" 业主经纪人 ";
    }else if ([_broker.isOwner isEqualToString:@"1"]) {
        self.type2.hidden = YES;
        self.type.text = @" 业主经纪人 ";
    }else if ([_broker.isStaff isEqualToString:@"1"]) {
        self.type2.hidden = YES;
        self.type.text = @" 员工经纪人 ";
    }else{
        self.type2.hidden = YES;
        self.type.text = @" 独立经纪人 ";
    }
    
    self.time.text = [NSString stringWithFormat:@"发展时间：%@",_broker.createTime];
    self.num.text = [NSString stringWithFormat:@"发展客户：%@人",_broker.cusNum];
}
- (IBAction)phoneClicked:(UIButton *)sender {
    if (self.phoneClickedCall) {
        self.phoneClickedCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
