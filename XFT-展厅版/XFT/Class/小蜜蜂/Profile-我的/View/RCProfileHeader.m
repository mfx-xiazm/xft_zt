//
//  RCProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileHeader.h"

@implementation RCProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)infoClick:(UIButton *)sender {
    if (self.infoClicked) {
        self.infoClicked();
    }
}
@end
