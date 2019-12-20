//
//  RCBrokerClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBrokerClientCell.h"
#import "RCBrokerClient.h"

@interface RCBrokerClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;

@end
@implementation RCBrokerClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCBrokerClient *)client
{
    _client = client;
    if (_client.phone && _client.phone.length) {
        self.phone.text = [NSString stringWithFormat:@"%@****%@",[_client.phone substringToIndex:3],[_client.phone substringFromIndex:_client.phone.length-4]];
    }else{
        self.phone.text = @"暂无电话";
    }
    /* 客户状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 其他101:已失效 */
    if (_client.status == 0) {
        self.cusState.text = @"已报备";
        self.cusState.backgroundColor = UIColorFromRGB(0x42CDC5);
        self.time1.hidden = YES;
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else if (_client.status == 2) {
        self.cusState.text = @"已到访";
        self.cusState.backgroundColor = UIColorFromRGB(0x428DCD);
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"到访时间:%@",_client.lastVistTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else if (_client.status == 4) {
        self.cusState.text = @"已认筹";
        self.cusState.backgroundColor = [UIColor greenColor];
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"认筹时间:%@",_client.transTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else if (_client.status == 5) {
        self.cusState.text = @"已认购";
        self.cusState.backgroundColor = UIColorFromRGB(0xCD9442);
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"认购时间:%@",_client.transTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else if (_client.status == 6) {
        self.cusState.text = @"已签约";
        self.cusState.backgroundColor = UIColorFromRGB(0xF39800);
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"签约时间:%@",_client.transTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else if (_client.status == 7) {
        self.cusState.text = @"已退房";
        self.cusState.backgroundColor = UIColorFromRGB(0xEC142D);
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"退房时间:%@",_client.transTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }else{
        self.cusState.text = @"已失效";
        self.cusState.backgroundColor = UIColorFromRGB(0xBCC8D6);
        self.time1.hidden = NO;
        self.time1.text = [NSString stringWithFormat:@"失效时间:%@",_client.invalidTime];
        self.time2.text = [NSString stringWithFormat:@"报备时间:%@",_client.baobeiTime];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
