//
//  RCDevelopClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/12/10.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCDevelopClientCell.h"
#import "RCClientType.h"

@interface RCDevelopClientCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation RCDevelopClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)delClicked:(UIButton *)sender {
    if (self.delClientCall) {
        self.delClientCall();
    }
}
-(void)setType:(RCClientType *)type
{
    _type = type;
    self.name.text = _type.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
