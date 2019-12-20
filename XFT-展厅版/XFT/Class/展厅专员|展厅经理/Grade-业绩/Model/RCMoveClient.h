//
//  RCMoveClient.h
//  XFT
//
//  Created by 夏增明 on 2019/12/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMoveClient : NSObject
@property(nonatomic,copy) NSString *baobeiUuid;//报备uuid
@property(nonatomic,copy) NSString *createTime;//报备时间/推荐时间
@property(nonatomic,copy) NSString *cusUuid;//到访客户uuid
@property(nonatomic,copy) NSString *name;//姓名
@property(nonatomic,copy) NSString *proName;//项目
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
