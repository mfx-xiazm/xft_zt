//
//  RCReportResultCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportResultCell.h"
#import "RCReportResult.h"

@interface RCReportResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *anme;
@property (weak, nonatomic) IBOutlet UILabel *mag;

@end

@implementation RCReportResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPerson:(RCReportResult *)person
{
    _person = person;
    self.anme.text = [NSString stringWithFormat:@"%@-%@\n报备项目：%@",_person.cusName,_person.cusPhone,_person.proName];
    if (self.isSuccess) {
        self.mag.text = @"";
    }else{
        self.mag.text = [NSString stringWithFormat:@"原因：%@",_person.msg];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
