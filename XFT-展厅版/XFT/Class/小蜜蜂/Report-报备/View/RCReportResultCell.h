//
//  RCReportResultCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportResult;
@interface RCReportResultCell : UITableViewCell
/* 报备结果 */
@property(nonatomic,assign) RCReportResult *person;
@property (weak, nonatomic) IBOutlet UILabel *nnum;
@end

NS_ASSUME_NONNULL_END
