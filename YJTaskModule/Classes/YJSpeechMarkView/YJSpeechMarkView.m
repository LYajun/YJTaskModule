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
+ (void)showSpeechMarkView{
    [self showSpeechMarkViewWithTitle:@"系统正在给你智能评分\n请稍候..."];
}
+ (void)showSpeechMarkViewWithTitle:(NSString *)title{
    YJSpeechMarkView *alertView = [[YJSpeechMarkView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView yj_clipLayerWithRadius:5 width:0 color:nil];
    UIImageView *gifImg = [[UIImageView alloc] initWithImage:[UIImage yj_animatedGIFNamed:@"yj_speech_mark" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
    [alertView addSubview:gifImg];
    [gifImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.centerY.equalTo(alertView).offset(-18);
        make.height.mas_equalTo(100);
        make.width.equalTo(gifImg.mas_height).multipliedBy(1.15);
    }];
    [gifImg layoutIfNeeded];
    [gifImg yj_clipLayerWithRadius:50 width:0 color:nil];
    
    UILabel *titleL = [UILabel new];
    titleL.text = title;
    titleL.numberOfLines = 2;
    titleL.textColor = [UIColor darkGrayColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = LG_SysFont(14);
    [alertView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.top.equalTo(gifImg.mas_bottom).offset(10);
    }];
    [alertView show];
}

+ (void)showSpeechRecognizeView{
    YJSpeechMarkView *alertView = [[YJSpeechMarkView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    alertView.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    alertView.backgroundColor = LG_ColorWithHexA(0x000000, 0.6);
    [alertView yj_clipLayerWithRadius:4 width:0 color:nil];
    UIImageView *gifImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [alertView addSubview:gifImg];
    [gifImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.centerY.equalTo(alertView).offset(-10);
        make.width.height.mas_equalTo(100);
    }];
    [gifImg layoutIfNeeded];
    [gifImg yj_clipLayerWithRadius:50 width:0 color:nil];
    gifImg.backgroundColor = [UIColor whiteColor];
    gifImg.animationImages = [YJSpeechMarkView yj_animationRecorderImages];
    gifImg.animationDuration = gifImg.animationImages.count * 0.05;
    [gifImg startAnimating];
    UILabel *titleL = [UILabel new];
    titleL.text = @"放开手指,完成录音";
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.top.equalTo(gifImg.mas_bottom).offset(6);
    }];
    [alertView show];
}
+ (NSArray<UIImage *> *)yj_animationRecorderImages{
    //     CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    NSFileManager *fielM = [NSFileManager defaultManager];
    NSArray *arrays = [fielM contentsOfDirectoryAtPath:[[YJTaskBundle() resourcePath] stringByAppendingPathComponent:@"RecorderGif"] error:nil];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < arrays.count; i++) {
        UIImage *image = [UIImage yj_imagePathName:[NSString stringWithFormat:@"Recorder_GIF_000%i",i+1] atDir:@"RecorderGif" atBundle:YJTaskBundle()];
        if (image) {
            [imageArr addObject:image];
        }
    }
    //     NSLog(@"loadingGifImg Linked in %f ms", (CFAbsoluteTimeGetCurrent() - startTime) *1000.0);
    return imageArr;
}
+ (void)dismiss{
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in rootWindow.subviews) {
        if ([view isKindOfClass:[YJSpeechMarkView class]]) {
            [(YJSpeechMarkView *)view hide];
        }
    }
}
- (void)show{
    [YJSpeechMarkView dismiss];
    UIWindow *rootWindow = [UIApplication sharedApplication].delegate.window;
    [rootWindow addSubview:self.maskView];
    [rootWindow addSubview:self];
    self.center = rootWindow.center;
    self.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                             CGAffineTransformMakeScale(0.7f, 0.7f));
    self.alpha = 0.0f;
    self.maskView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.alpha = 0.6f;
        weakSelf.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                     CGAffineTransformMakeScale(1.0f, 1.0f));
        weakSelf.alpha = 1.0f;
    }];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        weakSelf.maskView.alpha = 0.0f;
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL isFinished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor yj_colorWithHex:0x000000 alpha:0.4];
    }
    return _maskView;
}
@end
