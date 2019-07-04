//
//  YJSpeechClauseModel.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/8.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechClauseModel : LGBaseModel
/** 句子 */
@property (nonatomic,copy) NSString *sentence;
/** 得分 */
@property (nonatomic,copy) NSString *score;
/** 录音ID */
@property (nonatomic,copy) NSString *speechID;
@end

NS_ASSUME_NONNULL_END
