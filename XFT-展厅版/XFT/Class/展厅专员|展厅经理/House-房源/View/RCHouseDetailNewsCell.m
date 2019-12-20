//
//  RCHouseDetailNewsCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetailNewsCell.h"
#import "RCNews.h"

@interface RCHouseDetailNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lookNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
@implementation RCHouseDetailNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNews:(RCNews *)news
{
    _news = news;
    [self.newsImg sd_setImageWithURL:[NSURL URLWithString:_news.headPic]];
    [self.newsTitle setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"【%@】%@",_news.proName,_news.title] withFont:[UIFont systemFontOfSize:16]];
    self.lookNum.text = [NSString stringWithFormat:@"已查看%@人",_news.clickNum];
    self.time.text = _news.publishTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
