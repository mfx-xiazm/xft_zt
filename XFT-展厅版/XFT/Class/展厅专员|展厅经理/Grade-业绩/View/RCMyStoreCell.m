//
//  RCMyStoreCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyStoreCell.h"
#import "RCMyAgent.h"

@interface RCMyStoreCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopPic;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
@property (weak, nonatomic) IBOutlet UILabel *signNum;
@end
@implementation RCMyStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAgent:(RCMyAgent *)agent
{
    _agent = agent;
    [self.shopPic sd_setImageWithURL:[NSURL URLWithString:_agent.logoUrl] placeholderImage:HXGetImage(@"icon_zhongjie")];
    self.shopName.text = _agent.agentName;
    self.reportNum.text = [NSString stringWithFormat:@"推荐数：%@  到访数：%@",_agent.reportNum,_agent.visitNum];
    self.signNum.text = [NSString stringWithFormat:@"认购数：%@  签约数：%@",_agent.subNum,_agent.signingNum];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
