//
//  YJSpeechRecordAnswerView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechRecordAnswerView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJSpeechRecordView.h"

#import "YJSpeechRecordResultView.h"

@interface YJSpeechRecordAnswerView ()
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) UILabel *recordTitleLab;
@property (nonatomic,strong) YJSpeechRecordResultView *resultView;
@end
@implementation YJSpeechRecordAnswerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(0);
        make.width.height.mas_equalTo(80);
    }];
    
    [self addSubview:self.recordTitleLab];
    [self.recordTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.recordBtn.mas_bottom).offset(0);
    }];
    self.recordTitleLab.text = @"点击开始录音";
    
    
    [self addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.resultView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.resultView.removeRecordBlock = ^{
        if (weakSelf.removeRecordBlock) {
            weakSelf.removeRecordBlock();
        }
    };
    self.resultView.playBlock = ^{
        if (weakSelf.playBlock) {
            weakSelf.playBlock();
        }
    };
    self.resultView.UpdateTableBlock = ^(NSString * _Nonnull recordText) {
        if (weakSelf.UpdateTableBlock) {
            weakSelf.UpdateTableBlock(recordText);
        }
    };
}
- (void)recordAction{
    [YJSpeechRecordView showSpeechRecordView];
}
- (void)setRecordText:(NSString *)recordText{
    _recordText = recordText;
    self.resultView.recordText = recordText;
    self.resultView.hidden = IsStrEmpty(recordText);
    self.recordBtn.hidden = !self.resultView.hidden;
    self.recordTitleLab.hidden = !self.resultView.hidden;
}
- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    self.resultView.voiceUrl = voiceUrl;
}

- (void)invalidatePlayer{
    [self.resultView invalidatePlayer];
}
- (YJSpeechRecordResultView *)resultView{
    if (!_resultView) {
        _resultView = [[YJSpeechRecordResultView alloc] initWithFrame:CGRectZero];
    }
    return _resultView;
}
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage yj_imageNamed:@"record" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}
- (UILabel *)recordTitleLab{
    if (!_recordTitleLab) {
        _recordTitleLab = [UILabel new];
        _recordTitleLab.textAlignment = NSTextAlignmentCenter;
        _recordTitleLab.font = LG_SysFont(13);
        _recordTitleLab.textColor = LG_ColorWithHex(0x989898);
    }
    return _recordTitleLab;
}
@end
