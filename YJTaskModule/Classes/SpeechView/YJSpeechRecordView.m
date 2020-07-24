//
//  YJSpeechRecordView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechRecordView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJSpeechVoiceAnimationView.h"
#import <YJTaskMark/YJSpeechTimer.h>
#import <YJTaskMark/YJSpeechManager.h>
#import <LGAlertHUD/LGAlertHUD.h>

@interface YJSpeechRecordView ()
@property (nonatomic,strong) YJSpeechVoiceAnimationView *voiceAnimation;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) YJSpeechTimer *timer;
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) UILabel *recordTitleLab;
@property (nonatomic,assign) NSInteger timeCount;
@property(nonatomic,strong) UIView *maskView;
@end
@implementation YJSpeechRecordView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.voiceAnimation];
    [self.voiceAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self);
       make.top.equalTo(self.voiceAnimation.mas_bottom).offset(5);
    }];
    
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(40);
        make.width.height.mas_equalTo(90);
    }];
    
    [self addSubview:self.recordTitleLab];
    [self.recordTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.recordBtn.mas_bottom).offset(5);
    }];
    self.recordTitleLab.text = @"点击停止录音";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillResign:) name:UIApplicationWillResignActiveNotification object:nil];

}
- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)ApplicationWillResign:(NSNotification *) noti{
    [self recordAction];
}
+ (void)showSpeechRecordView{
    YJSpeechRecordView *recordView = [[YJSpeechRecordView alloc] initWithFrame:CGRectMake(0, LG_ScreenHeight, LG_ScreenWidth, LG_ScreenHeight*0.4)];
    recordView.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    recordView.maskView.backgroundColor = [UIColor darkGrayColor];
    recordView.maskView.alpha = 0.3;
   
    [recordView show];
}

- (void)show{
    UIView *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:self.maskView];
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformMakeTranslation(0, - self.frame.size.height);
    } completion:^(BOOL finished) {
        [self startTimer];
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)recordAction{
    [self removeTimer];
    [[YJSpeechManager defaultManager] stopEngineWithTip:@"语音识别中..."];
    [self hide];
}
- (void)startTimer{
    [[YJSpeechManager defaultManager] startEngineAtRefText:nil markType:YJSpeechMarkTypeASR];
    [self.voiceAnimation startAnimating];
    [self.timer fire];
}
- (void)removeTimer{
    [self.voiceAnimation stopAnimating];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerAction{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeCount++;
        weakSelf.timeLab.text = [NSString stringWithFormat:@"%@s",@(weakSelf.timeCount)];
        if (weakSelf.timeCount > 180) {
            [weakSelf recordAction];
        }
    });
}
- (YJSpeechVoiceAnimationView *)voiceAnimation{
    if (!_voiceAnimation) {
        _voiceAnimation = [[YJSpeechVoiceAnimationView alloc] initWithFrame:CGRectZero];
    }
    return _voiceAnimation;
}
- (YJSpeechTimer *)timer{
    if (!_timer) {
        _timer = [YJSpeechTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES dispatchQueue:dispatch_queue_create("YJSpeechRecordResultView", DISPATCH_QUEUE_CONCURRENT)];
    }
    return _timer;
}
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage yj_imageNamed:@"record" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = LG_SysFont(15);
        _timeLab.textColor = LG_ColorWithHex(0x989898);
    }
    return _timeLab;
}
- (UILabel *)recordTitleLab{
    if (!_recordTitleLab) {
        _recordTitleLab = [UILabel new];
        _recordTitleLab.textAlignment = NSTextAlignmentCenter;
        _recordTitleLab.font = LG_SysFont(15);
        _recordTitleLab.textColor = LG_ColorWithHex(0x989898);
    }
    return _recordTitleLab;
}

@end
