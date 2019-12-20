//
//  RCMyBeesCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBeesCell.h"
#import "RCMyBee.h"

@interface RCMyBeesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCMyBeesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBee:(RCMyBee *)bee
{
    _bee = bee;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_bee.headpic] placeholderImage:HXGetImage(@"pic_header")];
    self.name.text = _bee.name;
    self.phone.text = _bee.regPhone;
    self.count.text = [NSString stringWithFormat:@"已报备：%@人",_bee.count];
    self.time.text = [NSString stringWithFormat:@"添加时间：%@",_bee.createTime];
}
- (IBAction)resetClicked:(UIButton *)sender {
    if (self.resetPwdActionCall) {
        self.resetPwdActionCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
