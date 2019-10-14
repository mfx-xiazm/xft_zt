//
//  RCAddPhoneCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddPhoneCell.h"
#import "RCReportTarget.h"

@interface RCAddPhoneCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@end
@implementation RCAddPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneNum.delegate = self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _phone.cusPhone = [textField hasText]?textField.text:@"";
}
-(void)setPhone:(RCReportPhone *)phone
{
    _phone = phone;
    self.phoneNum.text = _phone.cusPhone;
}
- (IBAction)cutBtnClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
