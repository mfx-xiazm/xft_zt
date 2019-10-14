//
//  RCMaganerGrade.h
//  XFT
//
//  Created by 夏增明 on 2019/9/25.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMaganerGrade : NSObject
@property (nonatomic, assign) NSInteger cusBaoBeiAbolishNum;
@property (nonatomic, assign) NSInteger cusBaoBeiInvalidNum;
@property (nonatomic, assign) NSInteger cusBaoBeiRecognitionNum;
@property (nonatomic, assign) NSInteger cusBaoBeiReportNum;
@property (nonatomic, assign) NSInteger cusBaoBeiSignNum;
@property (nonatomic, assign) NSInteger cusBaoBeiSubscribeNum;
@property (nonatomic, assign) NSInteger cusBaoBeiVisitNum;
@property (nonatomic, strong) NSString * showroomName;
@property (nonatomic, strong) NSString * showroomUuid;
@property (nonatomic, strong) NSString * groupName;
@property (nonatomic, strong) NSString * groupUuid;
@property (nonatomic, strong) NSString * teamName;
@property (nonatomic, strong) NSString * teamUuid;
@property (nonatomic, strong) NSString * zyName;
@property (nonatomic, strong) NSString * zyUuid;

/** 自己手动计算的团队总人数 */
@property (nonatomic, assign) NSInteger totalNum;

@end

NS_ASSUME_NONNULL_END
