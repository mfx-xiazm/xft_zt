//
//  RCManagerMsgCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/17.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCManagerMsgCell.h"
#import "RCInnerMsg.h"

@interface RCManagerMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *content_txt;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
@implementation RCManagerMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInnerMsg:(RCInnerMsg *)innerMsg
{
    _innerMsg = innerMsg;
    /**1.客户失效通知,    2.客户到访通知,   3.客户成交(认购、签约)通知,    4.客户转入转出通知*/
    if ([_innerMsg.type isEqualToString:@"1"]) {
        self.titleL.text = @"失效通知";
    }else if ([_innerMsg.type isEqualToString:@"2"]) {
        self.titleL.text = @"到访通知";
    }else if ([_innerMsg.type isEqualToString:@"3"]) {
        self.titleL.text = @"成交通知";
    }else{
        self.titleL.text = @"转移通知";
    }
    self.content_txt.text = _innerMsg.content;
    self.time.text = _innerMsg.createDate;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
