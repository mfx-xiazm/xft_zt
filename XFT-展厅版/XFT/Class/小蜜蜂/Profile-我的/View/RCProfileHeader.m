//
//  RCProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileHeader.h"

@interface RCProfileHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@end

@implementation RCProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapClicked)];
    [self.headImg addGestureRecognizer:tap];
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.headpic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.name;
    self.phone.text = [MSUserManager sharedInstance].curUserInfo.showroomLoginInside.regPhone;
    self.nickName.text = [NSString stringWithFormat:@"用户名：%@",[MSUserManager sharedInstance].curUserInfo.showroomLoginInside.nick];
}
-(void)headTapClicked
{
    if (self.infoClicked) {
        self.infoClicked(1);
    }
}
- (IBAction)infoClick:(UIButton *)sender {
    if (self.infoClicked) {
        self.infoClicked(2);
    }
}
@end
