//
//  RCManagerProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerProfileHeader.h"

@interface RCManagerProfileHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *jgName;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *managerFlag;
@property (weak, nonatomic) IBOutlet UILabel *zhuanyuanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhuanyuanFlag;

@end

@implementation RCManagerProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.headpic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name;
    self.phone.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.regPhone;
    self.nickName.text = [NSString stringWithFormat:@"用户名：%@",[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.nick];
    
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.groupName && [MSUserManager sharedInstance].curUserInfo.selectRole.groupName.length) {
        self.jgName.text = [NSString stringWithFormat:@"%@-%@-%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName,[MSUserManager sharedInstance].curUserInfo.selectRole.teamName,[MSUserManager sharedInstance].curUserInfo.selectRole.groupName];
    }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.teamName && [MSUserManager sharedInstance].curUserInfo.selectRole.teamName.length) {
        self.jgName.text = [NSString stringWithFormat:@"%@-%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName,[MSUserManager sharedInstance].curUserInfo.selectRole.teamName];
    }else{
        self.jgName.text = [NSString stringWithFormat:@"%@",[MSUserManager sharedInstance].curUserInfo.selectRole.showRoomName];
    }
    
    if ([MSUserManager sharedInstance].curUserInfo.selectRole.isManager == 1 && [MSUserManager sharedInstance].curUserInfo.selectRole.isZy == 1) {
        self.managerLabel.text = @"展厅经理";
        self.managerLabel.hidden = NO;
        
        self.zhuanyuanLabel.text = @"展厅专员";
        self.zhuanyuanLabel.hidden = NO;
        
        if ([MSUserManager sharedInstance].curUserInfo.ulevel == 1) {
            self.managerFlag.hidden = NO;
            self.zhuanyuanFlag.hidden = YES;
        }else{
            self.managerFlag.hidden = YES;
            self.zhuanyuanFlag.hidden = NO;
        }
    }else if ([MSUserManager sharedInstance].curUserInfo.selectRole.isManager == 1) {
        self.managerLabel.text = @"展厅经理";
        self.managerLabel.hidden = NO;
        self.managerFlag.hidden = NO;
        self.zhuanyuanLabel.hidden = YES;
        self.zhuanyuanFlag.hidden = YES;
    }else{
        self.managerLabel.text = @"展厅专员";
        self.managerLabel.hidden = NO;
        self.managerFlag.hidden = NO;
        self.zhuanyuanLabel.hidden = YES;
        self.zhuanyuanFlag.hidden = YES;
    }
}

- (IBAction)infoClick:(UIButton *)sender {
    if (self.infoClicked) {
        self.infoClicked(sender.tag);
    }
}

@end
