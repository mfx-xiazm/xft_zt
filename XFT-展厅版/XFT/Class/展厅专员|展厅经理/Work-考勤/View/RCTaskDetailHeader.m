//
//  RCTaskDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailHeader.h"

@implementation RCTaskDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)moreClicked:(UIButton *)sender {
    if (self.lookMoreCall) {
        self.lookMoreCall();
    }
}

@end
