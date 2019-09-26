//
//  RCMaganerGrade.m
//  XFT
//
//  Created by 夏增明 on 2019/9/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMaganerGrade.h"

@implementation RCMaganerGrade
- (NSInteger)totalNum
{
    return _cusBaoBeiAbolishNum+_cusBaoBeiInvalidNum+_cusBaoBeiRecognitionNum+_cusBaoBeiReportNum+_cusBaoBeiSignNum+_cusBaoBeiSubscribeNum+_cusBaoBeiVisitNum;
}
@end
