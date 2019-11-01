//
//  RCReportResult.h
//  XFT
//
//  Created by 夏增明 on 2019/10/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCReportResult : NSObject
@property(nonatomic,copy) NSString *cusPhone;
@property(nonatomic,copy) NSString *cusName;
@property(nonatomic,copy) NSString *baoBeiState;
@property(nonatomic,copy) NSString *msg;
@property(nonatomic,copy) NSString *proUuid;
@property(nonatomic,copy) NSString *proName;
@end

NS_ASSUME_NONNULL_END
