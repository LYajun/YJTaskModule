//
//  YJTaskBlankCell.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@interface YJTaskBlankCell : LGBaseTableViewCell
@property (nonatomic,copy) NSString *answerStr;
@property (nonatomic,assign) BOOL editable;
/** 英译中隐藏语音评测按钮 */
@property (nonatomic,assign) BOOL hideSpeechBtn;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) void (^SpeechMarkBlock) (void);
@end
