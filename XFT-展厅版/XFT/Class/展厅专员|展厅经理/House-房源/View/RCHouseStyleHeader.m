//
//  RCHouseStyleHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleHeader.h"
#import "RCHouseInfo.h"

@interface RCHouseStyleHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *buildArea;
@property (weak, nonatomic) IBOutlet UILabel *roomArea;
@property (weak, nonatomic) IBOutlet UILabel *houseFace;

@end
@implementation RCHouseStyleHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)loanDetailClicked:(UIButton *)sender {
    if (self.loanDetailCall) {
        self.loanDetailCall();
    }
}

-(void)setHouseInfo:(RCHouseInfo *)houseInfo
{
    _houseInfo = houseInfo;
    self.name.text = [NSString stringWithFormat:@"%@户型详情",_houseInfo.name];
    self.buildArea.text = [NSString stringWithFormat:@"%@㎡",_houseInfo.buldArea];
    self.roomArea.text = [NSString stringWithFormat:@"%@㎡",_houseInfo.roomArea];
    self.houseFace.text = _houseInfo.houseFace;
}
@end
