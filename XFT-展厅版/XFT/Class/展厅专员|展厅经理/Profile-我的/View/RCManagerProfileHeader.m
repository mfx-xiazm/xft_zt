//
//  RCManagerProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerProfileHeader.h"

@interface RCManagerProfileHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *jgName;

@end

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
