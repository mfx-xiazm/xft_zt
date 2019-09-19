//
//  RCClientDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailHeader.h"

@implementation RCClientDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;

}
- (IBAction)detailClicked:(UIButton *)sender {
    if (self.clientDetailCall) {
        self.clientDetailCall(sender.tag);
    }
}

@end
