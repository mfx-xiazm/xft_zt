//
//  RCHousePicInfo.h
//  XFT
//
//  Created by 夏增明 on 2019/12/4.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RCHousePicInfoType) {
    RCHousePicInfoTypeVR = 0,
    RCHousePicInfoTypeVideo,
    RCHousePicInfoTypePicture
};

@interface RCHousePicInfo : NSObject
/* 类型 */
@property(nonatomic,assign) RCHousePicInfoType type;
/* 封面图 */
@property (nonatomic, strong) NSString * coverUrl;
/* 文件地址 */
@property (nonatomic, strong) NSString * url;
@end

NS_ASSUME_NONNULL_END
