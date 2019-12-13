//
//  RCBeesWorkCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCBeesWorkCell.h"
#import "RCBeesWork.h"

@interface RCBeesWorkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reportName;

@end
@implementation RCBeesWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBeesWork:(RCBeesWork *)beesWork
{
    _beesWork = beesWork;
    self.cusName.text = _beesWork.cusName;
    self.time.text = [NSString stringWithFormat:@"上报时间:%@",_beesWork.createTime];
    self.reportName.text = [NSString stringWithFormat:@"上报人员:%@",_beesWork.name];
}
- (IBAction)reportClicked:(UIButton *)sender {
    if (self.reportCall) {
        self.reportCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
