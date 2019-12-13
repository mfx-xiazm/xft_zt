//
//  RCTaskWorkCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkCell.h"
#import "RCTask.h"

@interface RCTaskWorkCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UILabel *haveVolume;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIProgressView *prorerss;
@property (weak, nonatomic) IBOutlet UILabel *progressTap;

@end
@implementation RCTaskWorkCell

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
    self.volume.text = _task.volume;
    self.haveVolume.text = (_task.finished && _task.finished.length)?_task.finished:@"0";
    self.count.text = _task.participantCount;
    if ([_task.state isEqualToString:@"1"]) {
        self.state.text = @"未开始";
        self.state.textColor = UIColorFromRGB(0x80CD42);
    }else if ([_task.state isEqualToString:@"2"]){
        self.state.text = @"进行中";
        self.state.textColor = HXControlBg;
    }else if ([_task.state isEqualToString:@"3"]){
        self.state.text = @"已结束";
        self.state.textColor = UIColorFromRGB(0xBCC8D6);
    }else{
        self.state.text = @"已终止";
        self.state.textColor = [UIColor redColor];
    }
    CGFloat pre = (_task.finished && _task.finished.length)?[_task.finished floatValue]/[_task.volume floatValue]:0;
    self.prorerss.progress = pre;
    self.progressTap.text = [NSString stringWithFormat:@"%.f%%",pre*100];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
