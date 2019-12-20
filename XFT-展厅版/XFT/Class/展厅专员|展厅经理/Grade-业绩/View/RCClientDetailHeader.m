//
//  RCClientDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailHeader.h"
#import "RCMyClient.h"

@interface RCClientDetailHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *state2;
/** 根据状态来显示对应的时间 */
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *guwen;
@property (weak, nonatomic) IBOutlet SPButton *phone;
@end
@implementation RCClientDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;

}
-(void)setClient:(RCMyClient *)client
{
    _client = client;
    self.codeBtn.hidden = ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) ?NO:YES;

    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 2) {//专员
        if (self.cusType == 0) {// 已报备状态
            self.codeBtn.hidden = NO;
        }else{
            self.codeBtn.hidden = YES;
        }
        self.followBtn.selected = [_client.isLove isEqualToString:@"1"]?YES:NO;
    }else{
        self.codeBtn.hidden = YES;
    }
    
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_client.headpic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text = _client.name;
//    if (_client.cusLevel && _client.cusLevel.length) {
//        self.state2.hidden = NO;
//        self.state2.text = [NSString stringWithFormat:@" %@ ",_client.cusLevel];
//    }else{
        self.state2.hidden = YES;
//    }
    switch (_client.cusType) {
        case 0:{
            self.state.text = [NSString stringWithFormat:@" %@天后失效 ",_client.baobeiYuqiTime];
            self.time.text = [NSString stringWithFormat:@"最后备注：%@",_client.remarkTime];
        }
            break;
        case 1:{
            self.state.text = @" 已到访 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_client.lastVistTime];
        }
            break;
        case 2:{
            self.state.text = @" 已认筹 ";
            self.time.text = [NSString stringWithFormat:@"认筹时间：%@",_client.transTime];
        }
            break;
        case 3:{
            self.state.text = @" 已认购 ";
            self.time.text = [NSString stringWithFormat:@"认购时间：%@",_client.transTime];
        }
            break;
        case 4:{
            self.state.text = @" 已签约 ";
            self.time.text = [NSString stringWithFormat:@"签约时间：%@",_client.transTime];
        }
            break;
        case 5:{
            self.state.text = @" 已退房 ";
            self.time.text = [NSString stringWithFormat:@"退房时间：%@",_client.transTime];
        }
            break;
        case 6:{
            self.state.text = @" 已失效 ";
            self.time.text = [NSString stringWithFormat:@"失效时间：%@",_client.invalidTime];
        }
            break;
    }
    if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {//经理
       self.guwen.text = (_client.accName && _client.accName.length)?[NSString stringWithFormat:@"展厅专员：%@(%@-%@)",_client.accName,_client.accTeamName,_client.accGroupName]:@"展厅专员：暂无";
    }else{
        self.guwen.text = (_client.salesName && _client.salesName.length)?[NSString stringWithFormat:@"案场顾问：%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName]:@"案场顾问：暂无";
    }
    
    [self.phone setTitle:_client.phone forState:UIControlStateNormal];
}
- (IBAction)detailClicked:(UIButton *)sender {
    if (self.clientDetailCall) {
        self.clientDetailCall(sender.tag,sender);
    }
}

@end
