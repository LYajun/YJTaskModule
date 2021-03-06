//
//  YJSpeechTalkListCell.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class YJSpeechTalkModel;
@interface YJSpeechTalkListCell : LGBaseTableViewCell
@property (nonatomic,strong) YJSpeechTalkModel *talkModel;
@end

NS_ASSUME_NONNULL_END
