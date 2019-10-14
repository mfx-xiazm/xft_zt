//
//  RCMyClientNote.h
//  XFT
//
//  Created by 夏增明 on 2019/9/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientNote : NSObject
@property (nonatomic, assign) NSInteger type;//状态转型0报备1到访2跟进3认筹4认购5签约6退房7失效8分配9转移
@property (nonatomic, strong) NSString * context;//备注
@property (nonatomic, strong) NSString * time;//时间

@property (nonatomic, strong) NSString * name;//名字
@property (nonatomic, strong) NSString * phone;//手机号
@property (nonatomic, strong) NSString * role;//职位

@end

NS_ASSUME_NONNULL_END
