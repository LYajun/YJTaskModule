//
//  YJSpeechMarkView.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechMarkView : UIView
+ (void)showSpeechMarkViewWithTitle:(NSString *)title;
+ (void)showSpeechMarkView;
+ (void)showSpeechRecognizeView;
+ (void)dismiss;
@end

NS_ASSUME_NONNULL_END
