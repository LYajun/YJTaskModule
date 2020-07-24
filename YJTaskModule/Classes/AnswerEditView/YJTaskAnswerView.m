//
//  YJTaskAnswerView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskAnswerView.h"
#import "YJTaskAnswerEditView.h"
#import "YJConst.h"


@interface YJTaskAnswerView ()
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *sureTitle;
@property (nonatomic,copy) void (^answerResultBlock) (NSString *result);
@end
@implementation YJTaskAnswerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}
- (void)layoutUI{
    YJTaskAnswerEditView *editView = [[YJTaskAnswerEditView alloc] initWithFrame:CGRectMake(0, LG_ScreenHeight-49, LG_ScreenWidth, 49)];
    [self addSubview:editView];
    __weak typeof(self) weakSelf = self;
    editView.answerResultBlock = self.answerResultBlock;
    editView.keyboardHideBlock = ^{
        [weakSelf hide];
    };
    editView.sureTitle = self.sureTitle;
    editView.textView.text = self.text;
}
+ (instancetype)showWithText:(NSString *)text answerResultBlock:(void (^)(NSString *))answerResultBlock{
    return [self showWithText:text sureTitle:@"确定" answerResultBlock:answerResultBlock];
}
+ (instancetype)showWithText:(NSString *)text sureTitle:(NSString *)sureTitle answerResultBlock:(void (^)(NSString *))answerResultBlock{
    YJTaskAnswerView *subView = [[YJTaskAnswerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    subView.text = text;
    subView.sureTitle = sureTitle;
    subView.answerResultBlock = answerResultBlock;
    [subView layoutUI];
    [subView show];
    return subView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}
- (void)hide{
     [self endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
