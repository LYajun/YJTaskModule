//
//  YJTaskBlankCell.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskBlankCell.h"
#import "LGBaseTextView.h"
#import <Masonry/Masonry.h>
#import <YJTaskMark/YJSpeechManager.h>
#import "YJSpeechMarkView.h"
#import "YJPaperModel.h"
#import <YJNetManager/YJNetMonitoring.h>
#import "YJConst.h"

@interface YJTaskBlankCell ()
@property (nonatomic,strong) UILabel *indexLab;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) UIButton *recordBtn;
@end
@implementation YJTaskBlankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.indexLab];
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_greaterThanOrEqualTo(44);
    }];
    UIView *bgView = [UIView new];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.left.equalTo(self.indexLab.mas_right).with.offset(5);
    }];
    BOOL isSpeechMarkEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
    
    [bgView addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_bottom).with.offset(0);
        make.right.equalTo(bgView.mas_right).with.offset(0);
        make.width.height.mas_equalTo(isSpeechMarkEnable ? 35 : 0);
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
- (void)setAnswerStr:(NSString *)answerStr{
    _answerStr = answerStr;
    self.textView.text = answerStr;
}
- (void)setEditable:(BOOL)editable{
    _editable = editable;
    if (editable) {
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
- (void)setIndex:(NSInteger)index{
    if (_index == index) {
        return;
    }
    _index = index;
    [self.indexLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(index < 0 ? 0:40);
    }];
    self.indexLab.text = [NSString yj_stringToSmallTopicIndexStringWithIntCount:index];
}

- (void)recordBtnLongTouchGes:(UILongPressGestureRecognizer *) longGes{
    if ([longGes state] == UIGestureRecognizerStateBegan) {
        [self.recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [[YJSpeechManager defaultManager] startEngineAtRefText:nil markType:YJSpeechMarkTypeASR];
        [YJSpeechMarkView showSpeechMarkViewWithTitle:@"系统正在给你识别\n请稍候..."];
    }else if ([longGes state] == UIGestureRecognizerStateEnded ||
              [longGes state] == UIGestureRecognizerStateCancelled){
        [self.recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [YJSpeechMarkView dismiss];
        [[YJSpeechManager defaultManager] stopEngineWithTip:@"语音识别中..."];
    }
}

- (UILabel *)indexLab{
    if (!_indexLab) {
        _indexLab = [UILabel new];
        _indexLab.textAlignment = NSTextAlignmentCenter;
        _indexLab.font = [UIFont systemFontOfSize:16];
        _indexLab.textColor = [UIColor darkGrayColor];
    }
    return _indexLab;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        _textView.placeholder = @"请输入...";
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
        _textView.maxLength = 100;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.userInteractionEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:16];
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
