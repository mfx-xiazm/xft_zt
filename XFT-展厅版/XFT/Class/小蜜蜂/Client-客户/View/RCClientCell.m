//
//  RCClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientCell.h"
#import "RCBeeClient.h"

@interface RCClientCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pro;

@end
@implementation RCClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCBeeClient *)client
{
    _client = client;
    self.name.text = _client.cusName;
    self.phone.text = _client.cusPhone;
    /** 0：小蜜蜂报备 1:专员放弃报备 2：专员报备成功 3：专员报备失败 */
    if ([_client.cusBaobeiState isEqualToString:@"1"]) {
        self.state.text = @"小蜜蜂报备";
    }else if ([_client.cusBaobeiState isEqualToString:@"2"]) {
        self.state.text = @"小蜜蜂报备";
    }else if ([_client.cusBaobeiState isEqualToString:@"3"]) {
        self.state.text = @"小蜜蜂报备";
    }else{
        self.state.text = @"小蜜蜂报备";
    }
    self.pro.text = [NSString stringWithFormat:@"报备项目:%@",_client.proName];
    self.time.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
