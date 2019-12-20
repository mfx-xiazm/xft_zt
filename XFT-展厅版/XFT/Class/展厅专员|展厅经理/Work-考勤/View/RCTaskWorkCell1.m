//
//  RCTaskWorkCell1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkCell1.h"
#import "RCTask.h"

@interface RCTaskWorkCell1 ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *volumeTag;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UILabel *haveVolume;
@property (weak, nonatomic) IBOutlet UIView *secView;

@end
@implementation RCTaskWorkCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTask:(RCTask *)task
{
    _task = task;
    self.title.text = [NSString stringWithFormat:@"%@【%@】",_task.name,_task.twoQudaoName];
    self.address.text = [NSString stringWithFormat:@"地点：%@",_task.address];
    self.time.text = [NSString stringWithFormat:@"时间：%@ 至 %@",_task.startTime,_task.endTime];
    if ([_task.state isEqualToString:@"1"]) {
        self.state.text = @"未开始";
        self.state.textColor = UIColorFromRGB(0x80CD42);
        self.volumeTag.text = @"目标(组)";
        self.volume.text = _task.volume;
        self.secView.hidden = YES;
    }else{
        self.state.text = @"已结束";
        self.state.textColor = UIColorFromRGB(0xBCC8D6);
        self.volumeTag.text = @"已拓(组)";
        self.volume.text = _task.haveVolume;
        self.secView.hidden = NO;
        self.haveVolume.text = _task.signCount;

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
