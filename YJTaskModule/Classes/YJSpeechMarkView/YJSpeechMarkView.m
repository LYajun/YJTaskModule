//
//  YJSpeechMarkView.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/7.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSpeechMarkView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>

@interface YJSpeechMarkView ()
@property(nonatomic,strong) UIView *maskView;
@end
@implementation YJSpeechMarkView

+ (id<YJSpeechMarkAlertProtocol>)speechMarkViewClass{
    id<YJSpeechMarkAlertProtocol> SpeechMarkView = (id<YJSpeechMarkAlertProtocol>)NSClassFromString(@"YJTaskSpeechMarkView");
    NSString *SpeechMarkViewClassName = [NSUserDefaults yj_stringForKey:YJTaskModule_SpeechAlertClassName_UserDefault_Key];
    if (!IsStrEmpty(SpeechMarkViewClassName)){
        SpeechMarkView = (id<YJSpeechMarkAlertProtocol>)NSClassFromString(SpeechMarkViewClassName);
    }
    return SpeechMarkView;
}

+ (void)showSpeechMarkView{
    [self showSpeechMarkViewWithTitle:@"系统正在给你智能评分\n请稍候..."];
}
+ (void)showSpeechMarkViewWithTitle:(NSString *)title{
    [[self speechMarkViewClass] showSpeechMarkViewWithTitle:title];
}

+ (void)showSpeechRecognizeView{
    [[self speechMarkViewClass] showSpeechRecognizeView];
}

+ (void)dismiss{
   [[self speechMarkViewClass] dismiss];
}

@end
