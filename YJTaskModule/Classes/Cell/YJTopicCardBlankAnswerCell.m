//
//  YJTopicCardBlankAnswerCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/15.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJTopicCardBlankAnswerCell.h"
#import "LGBaseTextView.h"
#import <YJNetManager/YJNetMonitoring.h>
#import <YJTaskMark/YJSpeechManager.h>
#import "YJSpeechMarkView.h"
#import "YJPaperModel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

@interface YJTopicCardBlankAnswerCell ()
@property (nonatomic,strong) UILabel *indexLab;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) UIButton *recordBtn;
@end
@implementation YJTopicCardBlankAnswerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.indexLab];
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(35);
    }];
    
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.left.equalTo(self.indexLab.mas_right).with.offset(0);
    }];
     BOOL isSpeechMarkEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
    [bgView addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).with.offset(isSpeechMarkEnable ? (IsIPad ? -15 : -10) : 0);
        make.right.equalTo(bgView.mas_right).with.offset(IsIPad ? - 10 : -5);
        make.width.height.mas_equalTo(isSpeechMarkEnable ? (IsIPad ? 32 : 28) : 0);
    }];
    self.recordBtn.hidden = !isSpeechMarkEnable;
    [bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left);
        make.bottom.equalTo(self.recordBtn.mas_top).with.offset(-4);
        make.height.greaterThanOrEqualTo(@(44));
    }];
    [bgView yj_clipLayerWithRadius:4 width:1 color:LG_ColorWithHex(0x78beff)];
}
- (void)setAnswer:(NSString *)answer{
    _answer = answer;
    self.textView.text = answer;
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    _topicIndex = topicIndex;
    self.indexLab.text = [NSString stringWithFormat:@"(%li)",topicIndex];
}
- (void)setPresentEnable:(BOOL)presentEnable{
    _presentEnable = presentEnable;
    if (presentEnable) {
        BOOL isOffline = [NSUserDefaults yj_boolForKey:UserDefaults_YJAnswerOfflineStatus];
        if (isOffline || [YJNetMonitoring shareMonitoring].networkCanUseState != 1 || ![YJSpeechManager defaultManager].isInitEngine) {
            self.recordBtn.enabled = NO;
        }else{
            self.recordBtn.enabled = YES;
        }
        self.textView.placeholder = @"请输入...";
    }else{
        self.recordBtn.enabled = NO;
        self.textView.placeholder = @"未作答";
    }
}
- (void)setHideSpeechBtn:(BOOL)hideSpeechBtn{
    _hideSpeechBtn = hideSpeechBtn;
    self.recordBtn.hidden = hideSpeechBtn;
}
- (void)recordBtnLongTouchGes:(UILongPressGestureRecognizer *) longGes{
    if ([longGes state] == UIGestureRecognizerStateBegan) {
        [self.recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [[YJSpeechManager defaultManager] startEngineAtRefText:nil markType:YJSpeechMarkTypeASR];
        [YJSpeechMarkView showSpeechRecognizeView];
        if (self.SpeechMarkBlock) {
            self.SpeechMarkBlock();
        }
    }else if ([longGes state] == UIGestureRecognizerStateEnded ||
              [longGes state] == UIGestureRecognizerStateCancelled){
        [self.recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [YJSpeechMarkView dismiss];
        [[YJSpeechManager defaultManager] stopEngineWithTip:@"语音识别中..."];
    }
}
- (UILabel *)indexLab{
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _indexLab.textColor = [UIColor darkGrayColor];
        _indexLab.font = [UIFont systemFontOfSize:16];
    }
    return _indexLab;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        _textView.placeholder = @"请输入...";
//        _textView.maxLength = 200;
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.userInteractionEnabled = NO;
    }
    return _textView;
}
- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_close" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateDisabled];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongTouchGes:)];
        longPress.minimumPressDuration = 0.2;
        [_recordBtn addGestureRecognizer:longPress];
    }
    return _recordBtn;
}
@end
