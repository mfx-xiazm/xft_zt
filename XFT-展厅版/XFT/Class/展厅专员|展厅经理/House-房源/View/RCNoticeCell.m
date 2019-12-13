//
//  RCNoticeCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNoticeCell.h"
#import "RCHouseNotice.h"

@interface RCNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *content_txt;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *lookMore;
@end
@implementation RCNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNotice:(RCHouseNotice *)notice
{
    _notice = notice;
    self.titleL.text = _notice.title;
    self.content_txt.text = _notice.context;
    self.time.text = _notice.publishTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
