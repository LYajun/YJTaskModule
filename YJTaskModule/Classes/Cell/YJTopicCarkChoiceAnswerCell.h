//
//  YJTopicCarkChoiceAnswerCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@interface YJTopicCarkChoiceAnswerCell : LGBaseTableViewCell
/** 题序 */
@property (nonatomic,assign) NSInteger topicIndex;
/** 答案 */
@property (nonatomic,copy) NSString *answer;
/** 小题数 */
@property (nonatomic,assign) NSInteger topicCount;
/** 作答回调 */
@property (nonatomic,copy) void (^answerResultBlock) (NSString *result);
@end
