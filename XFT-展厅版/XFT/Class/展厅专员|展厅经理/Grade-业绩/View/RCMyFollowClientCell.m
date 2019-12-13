//
//  RCMyFollowClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyFollowClientCell.h"
#import "RCMyFollow.h"

@interface RCMyFollowClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *baobeiPro;
@property (weak, nonatomic) IBOutlet UILabel *visitTime;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@end
@implementation RCMyFollowClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setFollow:(RCMyFollow *)follow
{
    _follow = follow;

    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_follow.cusPic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text  = _follow.name;
   
    self.time.text = [NSString stringWithFormat:@"报备时间：%@",_follow.createTime];
    self.baobeiPro.text = [NSString stringWithFormat:@"报备项目：%@",_follow.proName];
    
    switch (_follow.cusState) {
        case 0:{
            self.codeBtn.hidden = NO;
            self.state.text = [NSString stringWithFormat:@" %@天失效 ",_follow.baobeiYuqiTime];
            self.visitTime.text = [NSString stringWithFormat:@"备注时间：%@",_follow.time];
        }
            break;
        case 2:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已到访 ";
            self.visitTime.text = [NSString stringWithFormat:@"到访时间：%@",_follow.lastVistTime];
        }
            break;
        case 4:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已认筹 ";
            self.visitTime.text = [NSString stringWithFormat:@"到访时间：%@",_follow.lastVistTime];
        }
            break;
        case 5:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已认购 ";
            self.visitTime.text = [NSString stringWithFormat:@"到访时间：%@",_follow.lastVistTime];
        }
            break;
        case 6:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已签约 ";
            self.visitTime.text = [NSString stringWithFormat:@"到访时间：%@",_follow.lastVistTime];
        }
            break;
        case 7:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已退房 ";
            self.visitTime.text = [NSString stringWithFormat:@"到访时间：%@",_follow.lastVistTime];
        }
            break;
        case 8:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已失效 ";
            self.visitTime.text = [NSString stringWithFormat:@"备注时间：%@",_follow.time];
        }
            break;
        default:{
            self.codeBtn.hidden = YES;
            self.state.text = @" 已失效 ";
            self.visitTime.text = [NSString stringWithFormat:@"备注时间：%@",_follow.time];
        }
    }
    
    self.remark.text = (_follow.remark && _follow.remark.length)?[NSString stringWithFormat:@"备注内容：%@",_follow.remark]:@"备注内容：暂无";
    self.followBtn.selected =  [_follow.isLove isEqualToString:@"1"]?YES:NO;
}
- (IBAction)followToolClicked:(UIButton *)sender {
    if (self.fillowHandleCall) {
        self.fillowHandleCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
