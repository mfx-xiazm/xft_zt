//
//  RCMyOrganizationCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyOrganizationCell.h"

@interface RCMyOrganizationCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *upName;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCMyOrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRole:(MSUserRoles *)role
{
    _role = role;
    self.name.text = [NSString stringWithFormat:@"%@-%@-%@",_role.showRoomName,_role.teamName,_role.groupName];
    self.upName.text = [NSString stringWithFormat:@"归属上级:%@",_role.xqzyAccName];
    self.time.text = [NSString stringWithFormat:@"绑定时间:%@",_role.createTime];
}
- (IBAction)phoneClicked:(UIButton *)sender {
    if (self.phoneCall) {
        self.phoneCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
