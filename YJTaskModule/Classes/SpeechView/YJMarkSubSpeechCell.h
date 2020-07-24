//
//  YJMarkSubSpeechCell.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class YJBasePaperSmallModel;
@interface YJMarkSubSpeechCell : LGBaseTableViewCell
@property (nonatomic,assign) BOOL editable;
@property (nonatomic,assign) BOOL showRecommend;
/** 大题ID */
@property (nonatomic,copy) NSString *topicID;
/** 第几小题 */
@property (nonatomic,assign) NSInteger smallIndex;
@property (nonatomic,strong) YJBasePaperSmallModel *smallModel;
/** 标题 */
@property (nonatomic,copy) NSString *titleStr;
/** 标题颜色 */
@property (nonatomic,strong) UIColor *titleColor;
- (void)invalidatePlayer;
@end

NS_ASSUME_NONNULL_END
