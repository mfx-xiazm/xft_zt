//
//  RCTaskReport.h
//  XFT
//
//  Created by 夏增明 on 2019/12/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTaskReport : NSObject
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *uuid;
@end

NS_ASSUME_NONNULL_END
