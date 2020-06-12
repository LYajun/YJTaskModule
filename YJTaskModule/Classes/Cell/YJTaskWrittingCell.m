//
//  YJTaskWrittingCell.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/28.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJTaskWrittingCell.h"
#import "YJPaperModel.h"
#import "YJWrittingImageView.h"
#import <YJNetManager/YJNetMonitoring.h>
#import <YJTaskMark/YJSpeechManager.h>
#import "YJSpeechMarkView.h"
#import "LGBaseTextView.h"
#import <LGTalk/LGTPhotoBrowser.h>
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import <LGAlertHUD/YJLancooAlert.h>

@interface YJTaskWrittingCell ()
@property (nonatomic,strong) UILabel *indexLab;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) LGBaseHighlightBtn *recordBtn;
@property (strong,nonatomic) UIButton *textAnswerBtn;
@property (strong,nonatomic) UIButton *imgAnswerBtn;
@property (strong, nonatomic) UIView *answerBtnBgV;
@property (strong, nonatomic) UIView *contentBgV;
@property (strong, nonatomic) UIView *imageBgV;

@property (strong,nonatomic) LGTPhotoBrowser *photoBrowser;
@property (strong,nonatomic) YJWrittingImageView *addImageView;
@end
@implementation YJTaskWrittingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [tapBtn addTarget:self action:@selector(tapBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.answerBtnBgV addSubview:tapBtn];
        [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.answerBtnBgV);
        }];
        [self.contentView addSubview:self.answerBtnBgV];
        [self.answerBtnBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(44);
        }];
        
        [self.answerBtnBgV addSubview:self.imgAnswerBtn];
        [self.imgAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.answerBtnBgV).offset(2);
            make.centerY.equalTo(self.answerBtnBgV);
            make.right.equalTo(self.answerBtnBgV).offset(-6);
            make.width.equalTo(self.imgAnswerBtn.mas_height);
        }];
        
        [self.answerBtnBgV addSubview:self.textAnswerBtn];
        [self.textAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.answerBtnBgV);
            make.right.equalTo(self.imgAnswerBtn.mas_left).offset(-10);
            make.width.height.equalTo(self.imgAnswerBtn);
        }];
        
        
        [self.contentView addSubview:self.indexLab];
        [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.answerBtnBgV.mas_bottom);
            make.left.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(35);
        }];
        
        [self.contentView addSubview:self.contentBgV];
        [self.contentBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.answerBtnBgV.mas_bottom).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.left.equalTo(self.indexLab.mas_right).offset(0);
        }];
        
        BOOL isSpeechMarkEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
        
        [self.contentBgV addSubview:self.recordBtn];
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_SpecialTraining]) {
                make.bottom.equalTo(self.contentBgV).offset(isSpeechMarkEnable ? (IsIPad ? -10 : -5) : 0);
            }else{
                make.bottom.equalTo(self.contentBgV).offset(isSpeechMarkEnable ? (IsIPad ? -15 : -10) : 0);
            }
            make.right.equalTo(self.contentBgV).offset(IsIPad ? - 10 : -5);
            make.width.height.mas_equalTo(isSpeechMarkEnable ? (IsIPad ? 32 : 28) : 0);
        }];
        self.recordBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.recordBtn.hidden = !isSpeechMarkEnable;
        
        [self.contentBgV addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBgV);
            make.top.equalTo(self.contentBgV);
            make.left.equalTo(self.contentBgV);
            make.bottom.equalTo(self.recordBtn.mas_top).offset(-4);
            make.height.mas_greaterThanOrEqualTo([self.addImageView collectionViewItemWidth] - ((IsIPad ? 32+15 : 28+10)+4));
        }];
        [self.contentBgV yj_clipLayerWithRadius:4 width:1 color:LG_ColorWithHex(0xcacaca)];
        
        [self.contentView addSubview:self.imageBgV];
        [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentBgV);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.answerBtnBgV.mas_bottom).offset(0);
            make.height.mas_greaterThanOrEqualTo([self.addImageView collectionViewItemWidth]);
        }];
        
        [self.imageBgV addSubview:self.addImageView];
        [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.top.equalTo(self.imageBgV);
            make.height.mas_equalTo([self.addImageView collectionViewItemWidth]);
        }];
        
        self.imageBgV.hidden = YES;
    }
    return self;
}
- (void)tapBtnClickAction{};
- (void)recordBtnLongTouchGes:(UILongPressGestureRecognizer *) longGes{
    if ([longGes state] == UIGestureRecognizerStateBegan) {
        [[YJSpeechManager defaultManager] startEngineAtRefText:nil markType:YJSpeechMarkTypeASR];
        [YJSpeechMarkView showSpeechRecognizeView];
        if (self.SpeechMarkBlock) {
            self.SpeechMarkBlock();
        }
    }else if ([longGes state] == UIGestureRecognizerStateEnded ||
              [longGes state] == UIGestureRecognizerStateCancelled){
        [YJSpeechMarkView dismiss];
        [[YJSpeechManager defaultManager] stopEngineWithTip:@"语音识别中..."];
    }
}
- (void)textAnswerClickAction{
    if (!self.textAnswerBtn.selected) {
        if (!IsArrEmpty(self.smallModel.yj_imgUrlArr)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:@"切换为文本作答会删除图片内容，是否要切换？" cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_imgUrlArr = @[];
                    [weakSelf setContentBgVHidden:NO];
                    weakSelf.addImageView.smallModel = (YJPaperSmallModel *)weakSelf.smallModel;
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                [self setContentBgVHidden:NO];
            }];
        }
    }
}
- (void)imgAnswerClickAction{
    if (!self.imgAnswerBtn.selected) {
        if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:@"切换为图片作答会删除文本内容，是否要切换？" cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_smallAnswer = @"";
                    [weakSelf setContentBgVHidden:YES];
                    if (weakSelf.UpdateTableBlock) {
                        weakSelf.UpdateTableBlock();
                    }
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                [self setContentBgVHidden:YES];
            }];
        }
    }
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    if (_topicIndex == topicIndex) {
        return;
    }
    _topicIndex = topicIndex;
    [self.indexLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(topicIndex < 0 ? 0:35);
    }];
    self.indexLab.text = [NSString stringWithFormat:@"(%li)",topicIndex];
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
- (void)setHideSpeechBtn:(BOOL)hideSpeechBtn{
    _hideSpeechBtn = hideSpeechBtn;
    self.recordBtn.hidden = hideSpeechBtn;
}
- (void)setAnswerStr:(NSString *)answerStr{
    _answerStr = answerStr;
    self.textView.text = answerStr;
    if (!self.editable) {
        if (IsStrEmpty(answerStr) && IsArrEmpty(self.smallModel.yj_imgUrlArr)) {
            answerStr = [NSString yj_Char1];
        }
        [self.contentBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(IsStrEmpty(answerStr) ? 44 : -5);
        }];
        self.contentBgV.hidden = IsStrEmpty(answerStr);
    }
}
- (void)setSmallModel:(YJPaperSmallModel *)smallModel{
    _smallModel = smallModel;
    self.addImageView.hidden = !self.editable;
    
    BOOL isTextAnswer = YES;
    if (!IsArrEmpty(smallModel.yj_imgUrlArr) || self.imgAnswerBtn.selected) {
        isTextAnswer = NO;
    }

    
    
    if (self.editable) {
        BOOL isOffline = [NSUserDefaults yj_boolForKey:UserDefaults_YJAnswerOfflineStatus];
        
        BOOL isImgAnswerEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_ImgAnswerEnable_UserDefault_Key];
        if (!isImgAnswerEnable) {
            isOffline = YES;
        }
        self.addImageView.hidden = isOffline;
        if (!isOffline) {
            self.addImageView.smallModel = smallModel;
        }
        [self.answerBtnBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(isOffline ? 0 : 44);
        }];
//        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(isOffline ? 0 : [self.addImageView collectionViewItemWidth]);
//        }];
    }else{
         [self.answerBtnBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
//        if (IsArrEmpty(smallModel.yj_imgUrlArr)) {
//            [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(0);
//            }];
//        }else{
//            CGFloat imageBgW = self.photoBrowserWidth;
//            [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(imageBgW/3);
//            }];
            self.photoBrowser.imageUrls = smallModel.yj_imgUrlArr;
//        }
    }
    
    [self setContentBgVHidden:!isTextAnswer];
}
- (void)setContentBgVHidden:(BOOL)isHide{
    self.contentBgV.hidden = isHide;
    self.imageBgV.hidden = !self.contentBgV.hidden;
    self.textAnswerBtn.selected = !isHide;
    self.imgAnswerBtn.selected = !self.textAnswerBtn.selected;
    self.smallModel.yj_smallSimpleTextAnswer = self.textAnswerBtn.selected;
}
#pragma mark - Getter
- (CGFloat)photoBrowserWidth{
    CGFloat imageBgW = [self.addImageView collectionViewItemWidth]*3;
    return imageBgW;
}
- (UIView *)imageBgV{
    if (!_imageBgV) {
        _imageBgV = [UIView new];
    }
    return _imageBgV;
}
- (UIView *)contentBgV{
    if (!_contentBgV) {
        _contentBgV = [UIView new];
    }
    return _contentBgV;
}
- (UIView *)answerBtnBgV{
    if (!_answerBtnBgV) {
        _answerBtnBgV = [UIView new];
    }
    return _answerBtnBgV;
}
- (UILabel *)indexLab{
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _indexLab.textColor = [UIColor darkGrayColor];
        _indexLab.font = [UIFont systemFontOfSize:16];
    }
    return _indexLab;
}
- (LGTPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        _photoBrowser = [[LGTPhotoBrowser alloc] initWithFrame:CGRectZero width:self.photoBrowserWidth];
        [self.imageBgV addSubview:_photoBrowser];
        [_photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self.imageBgV);
            make.width.mas_equalTo(self.imageBgV.mas_height).multipliedBy(3);
        }];
    }
    return _photoBrowser;
}
- (YJWrittingImageView *)addImageView{
    if (!_addImageView) {
        _addImageView = [[YJWrittingImageView alloc] initWithFrame:CGRectZero];
    }
    return _addImageView;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        _textView.placeholder = @"请输入...";
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
//        _textView.maxLength = 1000;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.selectable = NO;
        _textView.userInteractionEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:17];
    }
    return _textView;
}
- (LGBaseHighlightBtn *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [LGBaseHighlightBtn buttonWithType:UIButtonTypeCustom];
        if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_SpecialTraining]) {
            [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_s_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
            [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_s_close" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateDisabled];
        }else{
            [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
            [_recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_close" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateDisabled];
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongTouchGes:)];
        longPress.minimumPressDuration = 0.2;
        [_recordBtn addGestureRecognizer:longPress];
    }
    return _recordBtn;
}
- (UIButton *)textAnswerBtn{
    if (!_textAnswerBtn) {
        _textAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_text_n" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_textAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_text_s" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_textAnswerBtn addTarget:self action:@selector(textAnswerClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textAnswerBtn;
}
- (UIButton *)imgAnswerBtn{
    if (!_imgAnswerBtn) {
        _imgAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_img_n" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_imgAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_img_s" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_imgAnswerBtn addTarget:self action:@selector(imgAnswerClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgAnswerBtn;
}
@end
