//
//  RCChooseMemberCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCChooseMemberCell.h"
#import "RCTaskMember.h"

@interface RCChooseMemberCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UILabel *formLabel;

@end
@implementation RCChooseMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAgentMember:(RCTaskAgentMember *)agentMember
{
    _agentMember = agentMember;
    self.name.text = agentMember.name;
    if (self.selectMoveAgent) {
        if ([self.selectMoveAgent.uuid isEqualToString:_agentMember.uuid]) {
            self.formLabel.hidden = NO;
            self.selBtn.hidden = YES;
        }else{
            self.formLabel.hidden = YES;
            self.selBtn.hidden = NO;
            self.selBtn.selected = _agentMember.isSelected?YES:NO;
        }
    }else{
        self.formLabel.hidden = YES;
        self.selBtn.hidden = NO;
        self.selBtn.selected = _agentMember.isSelected?YES:NO;
    }
}
- (IBAction)selectClicked:(UIButton *)sender {
    if (self.selectedCall) {
        self.selectedCall();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
