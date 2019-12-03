//
//  YJAnaSmallItem.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/22.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "YJTaskBaseSmallItem.h"

@class YJTaskTopicCell;
@interface YJAnaSmallItem : YJTaskBaseSmallItem
@property (nonatomic,strong) NSMutableArray *analysisArr;
@property (nonatomic,assign) NSInteger analysisMutiBlankRowCount;
@property (nonatomic,strong) YJTaskTopicCell *currentTaskTopicCell;
- (void)configAnalysisInfo;
- (BOOL)isShowKlgInfo;

@end

@interface YJAnaTeachSmallItem : YJAnaSmallItem

@end
