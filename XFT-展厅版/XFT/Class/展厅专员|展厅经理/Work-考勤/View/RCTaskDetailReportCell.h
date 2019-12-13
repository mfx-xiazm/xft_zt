//
//  RCTaskDetailReportCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/20.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTaskReport;
@interface RCTaskDetailReportCell : UITableViewCell
/* 报备 */
@property(nonatomic,strong) RCTaskReport *report;
@property (weak, nonatomic) IBOutlet UILabel *num;

@end

NS_ASSUME_NONNULL_END
