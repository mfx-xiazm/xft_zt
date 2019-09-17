//
//  RCManagerProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerProfileHeader.h"

@implementation RCManagerProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)infoClick:(UIButton *)sender {
    if (self.infoClicked) {
        self.infoClicked(sender.tag);
    }
}

@end
