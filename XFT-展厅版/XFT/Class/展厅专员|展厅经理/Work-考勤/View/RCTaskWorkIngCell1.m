//
//  RCTaskWorkIngCell1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkIngCell1.h"

@implementation RCTaskWorkIngCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)taskHandleClicked:(UIButton *)sender {
    if (self.taskWorkCall) {
        self.taskWorkCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
