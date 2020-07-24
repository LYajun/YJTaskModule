//
//  YJSpeechRecordResultView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/24.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechRecordResultView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import <YJUtils/YJAudioPlayer.h>
#import <LGAlertHUD/LGAlertHUD.h>
#import "LGBaseTextView.h"
#import "YJTaskWrittingView.h"
#import "YJSpeechTalkListView.h"

@interface YJSpeechRecordResultView ()<YJAudioPlayerDelegate>
@property (nonatomic,strong) UIButton *recordAnswerBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) LGBaseTextView *textView;
@property (nonatomic,strong) YJAudioPlayer *audioPlayer;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *talkBtn;
@property (nonatomic,strong) UIView *botView;
@end
@implementation YJSpeechRecordResultView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *recordBtnBgView = [UIView new];
    recordBtnBgView.backgroundColor = LG_ColorWithHex(0xD2E9FB);
    [recordBtnBgView yj_clipLayerWithRadius:4 width:0 color:nil];
    
    [self addSubview:recordBtnBgView];
    [recordBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(38);
    }];
    
    [recordBtnBgView addSubview:self.recordAnswerBtn];
    [self.recordAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(recordBtnBgView);
        make.left.equalTo(recordBtnBgView).offset(5);
        make.right.equalTo(recordBtnBgView).offset(-8);
    }];
    
    [recordBtnBgView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordBtnBgView).offset(-1);
         make.right.equalTo(recordBtnBgView).offset(1);
        make.width.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(24);
    }];
    
    [self.botView addSubview:self.likeBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.botView);
        make.left.equalTo(self.botView).offset(15);
    }];
    
    [self.botView addSubview:self.talkBtn];
    [self.talkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.botView);
        make.left.equalTo(self.likeBtn.mas_right).offset(30);
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(recordBtnBgView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.botView.mas_top).offset(-2);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [self.textView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidatePlayer) name:YJTaskModule_StopYJTaskTopicVoicePlay_Notification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapGesAction{
    [self.audioPlayer stop];
    __weak typeof(self) weakSelf = self;
    YJTaskTextEditView *answerView = [YJTaskTextEditView showWithText:self.recordText answerResultBlock:^(NSString *result) {
        if (weakSelf.UpdateTableBlock) {
            weakSelf.UpdateTableBlock(result);
        }
    }];
    answerView.titleStr = @"编辑录音内容";
}
- (void)stopPlayVoice{
    [self.audioPlayer stop];
    self.recordAnswerBtn.selected = NO;
}
- (void)invalidatePlayer{
    self.recordAnswerBtn.selected = NO;
    [self.audioPlayer invalidate];
}
- (void)setRecordText:(NSString *)recordText{
    _recordText = recordText;
    self.textView.text = recordText;
}
- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    if (!IsStrEmpty(voiceUrl)) {
        [self.recordAnswerBtn setTitle:[NSString stringWithFormat:@"作答音频(%.fs)",YJTaskAudioDurationFromURL(voiceUrl)] forState:UIControlStateNormal];
    }
}

- (void)deleteBtnAction{
     [self stopPlayVoice];
    __weak typeof(self) weakSelf = self;
    [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:@"确定要删除录音内容吗？" cancelTitle:@"我再想想" destructiveTitle:@"删除" cancelBlock:nil destructiveBlock:^{
        if (weakSelf.removeRecordBlock) {
            weakSelf.removeRecordBlock();
        }
    }] show];
}
- (void)voiceAction{
    if (self.playBlock) {
        self.playBlock();
    }
    
    if (self.audioPlayer.isPlaying) {
        [self stopPlayVoice];
        return;
    }
    
    [self.audioPlayer invalidate];
    self.audioPlayer.audioUrl = self.voiceUrl;
    [self.audioPlayer play];
    self.recordAnswerBtn.selected = YES;
}
- (void)likeBtnAction{
    
}
- (void)talkBtnAction{
    YJSpeechTalkListView *talkListView = [YJSpeechTalkListView speechTalkListView];
    talkListView.talkDataArr = @[@"",@"",@"",@""];
    [talkListView show];
}
#pragma mark - YJAudioPlayerDelegate
- (void)yj_audioPlayerDidPlayFailed{
    [LGAlert showStatus:@"播放失败"];
    [self stopPlayVoice];
}
- (void)yj_audioPlayerDecodeError{
    [LGAlert showStatus:@"播放失败"];
    [self stopPlayVoice];
}
- (void)yj_audioPlayerDidPlayComplete{
    [self stopPlayVoice];
}
- (void)yj_audioPlayerBeginInterruption{
    [self stopPlayVoice];
}
- (YJAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[YJAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage yj_imageNamed:@"delete" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIButton *)recordAnswerBtn{
    if (!_recordAnswerBtn) {
        _recordAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _recordAnswerBtn.titleLabel.font = LG_SysFont(16);
        [_recordAnswerBtn setTitleColor:LG_ColorWithHex(0x009CFF) forState:UIControlStateNormal];
        [_recordAnswerBtn setImage:[UIImage yj_imageNamed:@"record_play" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_recordAnswerBtn setImage:[UIImage yj_imageNamed:@"record_stop" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_recordAnswerBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
        [_recordAnswerBtn yj_setImagePosition:YJImagePositionLeft spacing:4];
    }
    return _recordAnswerBtn;
}
- (UIView *)botView{
    if (!_botView) {
        _botView = [UIView new];
    }
    return _botView;
}
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage yj_imageNamed:@"hp_like" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:LG_ColorWithHex(0xFF6900) forState:UIControlStateNormal];
        [_likeBtn setTitle:@"(24)" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = LG_SysFont(14);
        [_likeBtn addTarget:self action:@selector(likeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn yj_setImagePosition:YJImagePositionLeft spacing:4];
    }
    return _likeBtn;
}
- (UIButton *)talkBtn{
    if (!_talkBtn) {
        _talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_talkBtn setImage:[UIImage yj_imageNamed:@"task_talk" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_talkBtn setTitleColor:LG_ColorWithHex(0x42A4FA) forState:UIControlStateNormal];
        [_talkBtn setTitle:@"(24)" forState:UIControlStateNormal];
        _talkBtn.titleLabel.font = LG_SysFont(14);
        [_talkBtn addTarget:self action:@selector(talkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_talkBtn yj_setImagePosition:YJImagePositionLeft spacing:4];
    }
    return _talkBtn;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        _textView.placeholder = [NSString yj_Char1];
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.font = [UIFont systemFontOfSize:17];
        [_textView yj_clipLayerWithRadius:4 width:1 color:LG_ColorWithHex(0xcacaca)];
    }
    return _textView;
}
@end
