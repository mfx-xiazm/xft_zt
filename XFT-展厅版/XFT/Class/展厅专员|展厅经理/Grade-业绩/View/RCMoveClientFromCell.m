//
//  RCMoveClientFromCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClientFromCell.h"
#import "RCMoveClient.h"

@interface RCMoveClientFromCell ()
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *proName;

@end
@implementation RCMoveClientFromCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setClient:(RCMoveClient *)client
{
    _client = client;
    self.name.text = _client.name;
    self.proName.text = _client.proName;
    self.setBtn.selected = _client.isSelected?YES:NO;
    self.time.text = [NSString stringWithFormat:@"最近备注：%@",_client.createTime];
}
- (IBAction)selctentClicked:(UIButton *)sender {
    if (self.targetSelectCall) {
        self.targetSelectCall();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
