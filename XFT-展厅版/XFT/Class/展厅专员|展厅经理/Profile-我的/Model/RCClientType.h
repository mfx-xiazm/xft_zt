//
//  RCClientType.h
//  XFT
//
//  Created by 夏增明 on 2019/12/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCClientType : NSObject
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *showroomUuid;
@property(nonatomic,copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
