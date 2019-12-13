//
//  RCTaskDetailReportCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCTaskDetailReportCell.h"
#import "RCTaskReport.h"

@interface RCTaskDetailReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCTaskDetailReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setReport:(RCTaskReport *)report
{
    _report = report;
    self.name.text = _report.name;
    self.sex.text = [_report.sex isEqualToString:@"1"]?@"男":@"女";
    self.phone.text = _report.phone;
    self.time.text = _report.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
