//
//  RCAddTaskMemberCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddTaskMemberCell.h"
#import "RCTaskMember.h"

@interface RCAddTaskMemberCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation RCAddTaskMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMember:(RCTaskAgentMember *)member
{
    _member = member;
    self.name.text = _member.name;
    if ([_member.name isEqualToString:@"分配专员"]) {
        self.headerPic.image = HXGetImage(@"icon_add_head");
    }else{
        self.headerPic.image = HXGetImage(@"pic_header");
    }
}
@end
