//
//  YJSpeechTalkListView.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechTalkListView : UIView
@property (nonatomic,strong) NSArray *talkDataArr;
/** 大题ID */
@property (nonatomic,copy) NSString *topicID;
/** 第几小题 */
@property (nonatomic,assign) NSInteger smallIndex;
@property (nonatomic,assign) BOOL publishEnable;
@property (nonatomic, copy) void(^pulishSuccessBlock)(void);
+ (YJSpeechTalkListView *)speechTalkListView;
- (void)show;
@end

NS_ASSUME_NONNULL_END
