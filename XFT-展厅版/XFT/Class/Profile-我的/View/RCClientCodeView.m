//
//  RCClientCodeView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientCodeView.h"
#import "SGQRCode.h"

@interface RCClientCodeView ()
@property (weak, nonatomic) IBOutlet UIView *fillView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;

@end
@implementation RCClientCodeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self bezierPathByRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    
    self.codeImg.image = [SGQRCodeObtain generateQRCodeWithData:@"来一个字符串" size:self.codeImg.bounds.size.width];
}
- (IBAction)closeBtnClicked:(UIButton *)sender {
    if (self.closeBtnCall) {
        self.closeBtnCall();
    }
}

- (IBAction)fillSureClicked:(UIButton *)sender {
    self.fillView.hidden = YES;
    self.codeView.hidden = NO;
}

@end
