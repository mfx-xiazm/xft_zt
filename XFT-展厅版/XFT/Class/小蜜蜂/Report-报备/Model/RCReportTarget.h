//
//  RCReportTarget.h
//  XFT
//
//  Created by 夏增明 on 2019/10/11.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportPhone;
@interface RCReportTarget : NSObject
/* 客户姓名 */
@property(nonatomic,copy) NSString *cusName;
/* 客户电话 */
@property(nonatomic,copy) NSString *cusPhone;
/* 更多客户电话 */
@property(nonatomic,strong) NSMutableArray<RCReportPhone *> *morePhones;
/* 报备房源 */
@property(nonatomic,strong) NSMutableArray *selectHouses;
/* 身份证号 */
@property(nonatomic,copy) NSString *idCard;
/* 客户照片 */
@property(nonatomic,copy) NSString *headPic;
/* 客户备注 */
@property(nonatomic,copy) NSString *remark;
@end

@interface RCReportPhone : NSObject
/* 客户电话 */
@property(nonatomic,copy) NSString *cusPhone;
@end
NS_ASSUME_NONNULL_END
