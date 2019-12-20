//
//  RCMyClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientCell.h"
#import "RCMyClient.h"

@interface RCMyClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state2;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *baobeiPro;
@property (weak, nonatomic) IBOutlet UILabel *guwen;
@property (weak, nonatomic) IBOutlet UILabel *remarkTime;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end
@implementation RCMyClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCMyClient *)client
{
    _client = client;

//    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_client.headpic]];
    self.name.text  = _client.name;
//    if (_client.cusLevel && _client.cusLevel.length) {
//        self.state2.hidden = NO;
//        self.state2.text = [NSString stringWithFormat:@" %@ ",_client.cusLevel];
//    }else{
        self.state2.hidden = YES;
//    }
    self.time.text = [NSString stringWithFormat:@"报备时间：%@",_client.baobeiTime];
    self.baobeiPro.text = [NSString stringWithFormat:@"报备项目：%@",_client.proName];
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
       self.guwen.text = (_client.accName && _client.accName.length)?[NSString stringWithFormat:@"展厅专员：%@(%@-%@)",_client.accName,_client.accTeamName,_client.accGroupName]:@"展厅专员：暂无";
    }else{
        self.guwen.text = (_client.salesName && _client.salesName.length)?[NSString stringWithFormat:@"案场顾问：%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName]:@"案场顾问：暂无";
    }
    
    switch (self.cusType) {
        case 0:{
            self.state.text = [NSString stringWithFormat:@" %@天失效 ",_client.baobeiYuqiTime];
            self.remarkTime.text = [NSString stringWithFormat:@"最后备注：%@",_client.remarkTime];
        }
            break;
        case 1:{
            self.state.text = @" 已到访 ";
            self.remarkTime.text = [NSString stringWithFormat:@"最近到访：%@",_client.lastVistTime];
        }
            break;
        case 2:{
            self.state.text = @" 已认筹 ";
            self.remarkTime.text = [NSString stringWithFormat:@"认筹时间：%@",_client.transTime];
        }
            break;
        case 3:{
            self.state.text = @" 已认购 ";
            self.remarkTime.text = [NSString stringWithFormat:@"认购时间：%@",_client.transTime];
        }
            break;
        case 4:{
            self.state.text = @" 已签约 ";
            self.remarkTime.text = [NSString stringWithFormat:@"签约时间：%@",_client.transTime];
        }
            break;
        case 5:{
            self.state.text = @" 已退房 ";
            self.remarkTime.text = [NSString stringWithFormat:@"退房时间：%@",_client.transTime];
        }
            break;
        case 6:{
            self.state.text = @" 已失效 ";
            self.remarkTime.text = [NSString stringWithFormat:@"失效时间：%@",_client.invalidTime];
        }
            break;
    }
    self.remark.text = (_client.remark && _client.remark.length)?[NSString stringWithFormat:@"备注内容：%@",_client.remark]:@"备注内容：暂无";
    
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) {//专员
        if (self.cusType == 0) {//报备
            self.codeBtn.hidden = NO;
        }else{
            self.codeBtn.hidden = YES;
        }
        self.followBtn.selected =  [_client.isLove isEqualToString:@"1"]?YES:NO;
    }
}
- (IBAction)clientToolClicked:(UIButton *)sender {
    if (self.clientHandleCall) {
        self.clientHandleCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

