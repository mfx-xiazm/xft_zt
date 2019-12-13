//
//  RCStoreClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCStoreClientCell.h"
#import "RCStoreClient.h"

@interface RCStoreClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *saleMan;
@property (weak, nonatomic) IBOutlet UILabel *reportName;

@end
@implementation RCStoreClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCStoreClient *)client
{
    _client = client;

    if (_client.name.length > 1) {
        if (_client.name.length == 2) {
            self.name.text = [NSString stringWithFormat:@"%@*",[_client.name substringToIndex:1]];
        }else if (_client.name.length == 3) {
            self.name.text = [NSString stringWithFormat:@"%@**",[_client.name substringToIndex:1]];
        }else{
            self.name.text = [NSString stringWithFormat:@"%@***",[_client.name substringToIndex:1]];
        }
    }else{
        self.name.text = _client.name;
    }
    if ([_client.sex isEqualToString:@"1"]) {
        self.sex.text = @" 男 ";
    }else{
        self.sex.text = @" 女 ";
    }
    /* 客户状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 其他100:已失效 */
    if ([_client.cusState isEqualToString:@"0"]) {
        self.state.text = @"已报备";
        self.state.backgroundColor = UIColorFromRGB(0x42CDC5);
        self.saleMan.hidden = YES;
        self.time.text = [NSString stringWithFormat:@"报备时间:%@",_client.createTime];
    }else if ([_client.cusState isEqualToString:@"2"]) {
        self.state.text = @"已到访";
        self.state.backgroundColor = UIColorFromRGB(0x428DCD);
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"到访时间:%@",_client.lastVistTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }else if ([_client.cusState isEqualToString:@"4"]) {
        self.state.text = @"已认筹";
        self.state.backgroundColor = [UIColor greenColor];
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"认筹时间:%@",_client.transTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }else if ([_client.cusState isEqualToString:@"5"]) {
        self.state.text = @"已认购";
        self.state.backgroundColor = UIColorFromRGB(0xCD9442);
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"认购时间:%@",_client.transTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }else if ([_client.cusState isEqualToString:@"6"]) {
        self.state.text = @"已签约";
        self.state.backgroundColor = UIColorFromRGB(0xF39800);
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"签约时间:%@",_client.transTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }else if ([_client.cusState isEqualToString:@"7"]) {
        self.state.text = @"已退房";
        self.state.backgroundColor = UIColorFromRGB(0xEC142D);
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"退房时间:%@",_client.transTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }else{
        self.state.text = @"已失效";
        self.state.backgroundColor = UIColorFromRGB(0xBCC8D6);
        self.saleMan.hidden = NO;
        self.time.text = [NSString stringWithFormat:@"失效时间:%@",_client.transTime];
        self.saleMan.text = [NSString stringWithFormat:@"案场顾问:%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
    }
    if ([_client.accType isEqualToString:@"5"]) {
        self.reportName.text = [NSString stringWithFormat:@"报备人:%@(统一报备人)",_client.accName];
    }else if ([_client.accType isEqualToString:@"6"]) {
        self.reportName.text = [NSString stringWithFormat:@"报备人:%@(门店管理员)",_client.accName];
    }else{
        self.reportName.text = [NSString stringWithFormat:@"报备人:%@(门店经纪人)",_client.accName];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
