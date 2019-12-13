//
//  RCMyAgent.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyAgent : NSObject
@property(nonatomic,copy) NSString *agentUuid;
@property(nonatomic,copy) NSString *logoUrl;
@property(nonatomic,copy) NSString *agentName;
@property(nonatomic,copy) NSString *reportNum;
@property(nonatomic,copy) NSString *visitNum;
@property(nonatomic,copy) NSString *subNum;
@property(nonatomic,copy) NSString *signingNum;

@end

NS_ASSUME_NONNULL_END
