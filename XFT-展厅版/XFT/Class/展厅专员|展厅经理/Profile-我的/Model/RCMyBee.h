//
//  RCMyBee.h
//  XFT
//
//  Created by 夏增明 on 2019/12/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyBee : NSObject
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *regPhone;
@property(nonatomic,copy) NSString *headpic;
@property(nonatomic,copy) NSString *count;

@end

NS_ASSUME_NONNULL_END
