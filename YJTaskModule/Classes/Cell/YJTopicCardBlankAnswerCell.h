//
//  YJTopicCardBlankAnswerCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/15.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@interface YJTopicCardBlankAnswerCell : LGBaseTableViewCell
/** 题序 */
@property (nonatomic,assign) NSInteger topicIndex;
/** 答案 */
@property (nonatomic,copy) NSString *answer;
/** 弹出作答视图开关 */
@property (nonatomic,assign) BOOL presentEnable;


@property (nonatomic,copy) void (^SpeechMarkBlock) (void);
@end
