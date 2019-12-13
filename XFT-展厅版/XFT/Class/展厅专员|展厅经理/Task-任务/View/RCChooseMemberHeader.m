//
//  RCChooseMemberHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChooseMemberHeader.h"
#import "RCTaskMember.h"

@interface RCChooseMemberHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@end
@implementation RCChooseMemberHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setMember:(RCTaskMember *)member
{
    _member = member;
    self.name.text = [NSString stringWithFormat:@"%@-%@",_member.teamName,_member.groupName];
    self.tipImageView.transform = _member.isExpand ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    self.selectAllBtn.selected = _member.isCheckAll;
}
- (IBAction)checkAllClicked:(UIButton *)sender {
    if (self.checkAllCall) {
        self.checkAllCall();
    }
}

- (IBAction)headerClicked:(UIButton *)sender {
    if (self.expandCall) {
        self.expandCall();
    }
}

@end
