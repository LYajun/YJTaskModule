//
//  YJCorrectAnswerView.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YJCorrectAnswerView;
@protocol YJCorrectAnswerViewDelegate <NSObject>

@optional
- (void)YJCorrectAnswerView:(YJCorrectAnswerView *)answerView didFinishAnswer:(NSString *)answerStr;
- (void)YJCorrectAnswerViewBeginEditing;
@end
@interface YJCorrectAnswerView : UIView
- (instancetype)initWithAnswerWidth:(CGFloat)width placehold:(NSString *)placehold delegate:(id<YJCorrectAnswerViewDelegate>)delegate;
- (void)showRelyOnView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
