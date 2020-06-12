//
//  YJTaskWrittingCell.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/28.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class YJBasePaperSmallModel;
@interface YJTaskWrittingCell : LGBaseTableViewCell
/** 题序 */
@property (nonatomic,assign) NSInteger topicIndex;
@property (nonatomic,assign) BOOL editable;
@property (nonatomic,copy) NSString *answerStr;
@property (nonatomic,strong) YJBasePaperSmallModel *smallModel;
/** 英译中隐藏语音评测按钮 */
@property (nonatomic,assign) BOOL hideSpeechBtn;
@property (nonatomic,copy) void (^SpeechMarkBlock) (void);
@property (nonatomic,copy) void (^UpdateTableBlock) (void);
@end

NS_ASSUME_NONNULL_END
