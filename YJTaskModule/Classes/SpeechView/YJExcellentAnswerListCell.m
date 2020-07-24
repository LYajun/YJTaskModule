//
//  YJExcellentAnswerListCell.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJExcellentAnswerListCell.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "LGBaseTextView.h"
#import "YJSpeechTalkListView.h"
#import <YJUtils/YJAudioPlayer.h>
#import <LGAlertHUD/LGAlertHUD.h>

@interface YJExcellentAnswerListCell ()<YJAudioPlayerDelegate>
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) LGBaseTextView *textView;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UIButton *talkBtn;
@property (nonatomic,strong) UIView *botView;
@property (nonatomic,strong) YJAudioPlayer *audioPlayer;
@end
@implementation YJExcellentAnswerListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(6);
        make.top.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-160);
    }];
    
    
    UIView *recordBtnBgView = [UIView new];
    recordBtnBgView.backgroundColor = LG_ColorWithHex(0xD2E9FB);
    [recordBtnBgView yj_clipLayerWithRadius:4 width:0 color:nil];
    
    [self.contentView addSubview:recordBtnBgView];
    [recordBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.left.equalTo(self.titleLab.mas_right).offset(4);
        make.height.mas_equalTo(35);
    }];
    
    [recordBtnBgView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(recordBtnBgView);
        make.left.equalTo(recordBtnBgView).offset(5);
        make.right.equalTo(recordBtnBgView).offset(-5);
    }];
//    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [recordBtnBgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.contentView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(24);
    }];
    
    [self.botView addSubview:self.likeBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.botView);
        make.left.equalTo(self.botView).offset(18);
    }];
    
    [self.botView addSubview:self.talkBtn];
    [self.talkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.botView);
        make.left.equalTo(self.likeBtn.mas_right).offset(30);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.botView.mas_top).offset(-2);
    }];
    
    
    self.titleLab.text = @"【李帅晒(20180989)】";
    [self.voiceBtn setTitle:[NSString stringWithFormat:@"作答音频(%.fs)",56.0] forState:UIControlStateNormal];
    self.textView.text = @"啊，的健身房拉就是课件埃里克森附件点击发了撒附件放得开的沙拉发的客服颇尔法拉克发福利";
}
- (void)voiceAction{
  
}
- (void)likeBtnAction{
    
}
- (void)talkBtnAction{
    YJSpeechTalkListView *talkListView = [YJSpeechTalkListView speechTalkListView];
    talkListView.talkDataArr = @[@"",@"",@"",@""];
    [talkListView show];
}
- (void)stopPlayVoice{
    [self.audioPlayer stop];
    self.voiceBtn.selected = NO;
}
- (void)invalidatePlayer{
    self.voiceBtn.selected = NO;
    [self.audioPlayer invalidate];
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
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    return _titleLab;
}
- (YJAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[YJAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         _voiceBtn.titleLabel.font = LG_SysFont(16);
        [_voiceBtn setTitleColor:LG_ColorWithHex(0x009CFF) forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage yj_imageNamed:@"record_play" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage yj_imageNamed:@"record_stop" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn yj_setImagePosition:YJImagePositionLeft spacing:4];
    }
    return _voiceBtn;
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
    }
    return _textView;
}
@end
