//
//  RCTaskWorkIngCell1.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskWorkIngCell1.h"
#import "RCTask.h"

@interface RCTaskWorkIngCell1 ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UILabel *haveVolume;

@end
@implementation RCTaskWorkIngCell1

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
    self.haveVolume.text = _task.haveVolume;
}
- (IBAction)taskHandleClicked:(UIButton *)sender {
    if (self.taskWorkCall) {
        self.taskWorkCall(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
