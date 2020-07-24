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
#import "YJSpeechRecordAnswerView.h"
#import "YJSpeechUploadAnswerView.h"
#import "YJMemberTitleView.h"

@interface YJTaskWrittingCell ()
@property (nonatomic,strong) UILabel *indexLab;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) LGBaseHighlightBtn *recordBtn;
@property (strong,nonatomic) UIButton *textAnswerBtn;
@property (strong,nonatomic) UIButton *imgAnswerBtn;
@property (strong,nonatomic) UIButton *recordAnswerBtn;
@property (strong,nonatomic) UIButton *uploadAnswerBtn;
@property (strong,nonatomic) YJMemberTitleView *memberTitleView;

@property (strong, nonatomic) UIView *answerBtnBgV;
@property (strong, nonatomic) UIView *contentBgV;
@property (strong, nonatomic) UIView *imageBgV;
@property (strong, nonatomic) YJSpeechRecordAnswerView *recordView;
@property (strong, nonatomic) YJSpeechUploadAnswerView *uploadView;

@property (strong,nonatomic) LGTPhotoBrowser *photoBrowser;
@property (strong,nonatomic) YJWrittingImageView *addImageView;

/** 主观题作答模式：0-文本，1-图片，2-录音，3-上传 */
@property (nonatomic,assign) NSInteger subjectAnswerType;
@end
@implementation YJTaskWrittingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         BOOL isSpeechAnswerEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_SpeechAnswerEnable_UserDefault_Key];
        
        UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [tapBtn addTarget:self action:@selector(tapBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.answerBtnBgV addSubview:tapBtn];
        [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.answerBtnBgV);
        }];
        
        [self.contentView addSubview:self.memberTitleView];
        [self.memberTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(isSpeechAnswerEnable ? 40 : 0);
        }];
        self.memberTitleView.hidden = !isSpeechAnswerEnable;
        
        [self.contentView addSubview:self.answerBtnBgV];
        [self.answerBtnBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.memberTitleView.mas_bottom).offset(5);
            make.left.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(44);
        }];
        
        [self.answerBtnBgV addSubview:self.uploadAnswerBtn];
        [self.uploadAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.answerBtnBgV).offset(2);
            make.centerY.equalTo(self.answerBtnBgV);
            make.right.equalTo(self.answerBtnBgV).offset(-6);
            make.width.equalTo(self.uploadAnswerBtn.mas_height);
        }];
        
        [self.answerBtnBgV addSubview:self.recordAnswerBtn];
        [self.recordAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.answerBtnBgV);
            make.right.equalTo(self.uploadAnswerBtn.mas_left).offset(-10);
            make.width.height.equalTo(self.uploadAnswerBtn);
        }];
        
        self.uploadAnswerBtn.hidden = !isSpeechAnswerEnable;
        self.recordAnswerBtn.hidden = !isSpeechAnswerEnable;
        
        [self.answerBtnBgV addSubview:self.imgAnswerBtn];
        [self.imgAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.answerBtnBgV);
            if (isSpeechAnswerEnable) {
                make.right.equalTo(self.recordAnswerBtn.mas_left).offset(-10);
            }else{
                make.right.equalTo(self.answerBtnBgV).offset(-6);
            }
            make.width.height.equalTo(self.uploadAnswerBtn);
        }];
        
        [self.answerBtnBgV addSubview:self.textAnswerBtn];
        [self.textAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.answerBtnBgV);
            make.right.equalTo(self.imgAnswerBtn.mas_left).offset(-10);
            make.width.height.equalTo(self.uploadAnswerBtn);
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
        
        if (isSpeechAnswerEnable) {
            [self.contentView addSubview:self.recordView];
            [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentBgV);
                make.bottom.equalTo(self.contentView).offset(-5);
                make.top.equalTo(self.answerBtnBgV.mas_bottom).offset(0);
                make.height.mas_greaterThanOrEqualTo([self.addImageView collectionViewItemWidth]);
            }];
            
            [self.contentView addSubview:self.uploadView];
            [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentBgV);
                make.bottom.equalTo(self.contentView).offset(-5);
                make.top.equalTo(self.answerBtnBgV.mas_bottom).offset(0);
                make.height.mas_greaterThanOrEqualTo([self.addImageView collectionViewItemWidth]);
            }];
            
            self.recordView.hidden = YES;
            self.uploadView.hidden = YES;
            __weak typeof(self) weakSelf = self;
            
            self.recordView.playBlock = ^{
                if (weakSelf.playBlock) {
                    weakSelf.playBlock();
                }
            };
            self.recordView.removeRecordBlock = ^{
                weakSelf.smallModel.yj_recordAnswerUrl = @"";
                weakSelf.smallModel.yj_recordAnswerText = @"";
                if (weakSelf.UpdateTableBlock) {
                    weakSelf.UpdateTableBlock();
                }
            };
            self.recordView.UpdateTableBlock = ^(NSString * _Nonnull recordText) {
                weakSelf.smallModel.yj_recordAnswerText = recordText;
                if (weakSelf.UpdateTableBlock) {
                    weakSelf.UpdateTableBlock();
                }
            };
            self.uploadView.playBlock = ^{
                if (weakSelf.playBlock) {
                    weakSelf.playBlock();
                }
            };
            self.uploadView.removeRecordBlock = ^{
                weakSelf.smallModel.yj_uploadAnswerUrl = @"";
                weakSelf.smallModel.yj_uploadAnswerText = @"";
                if (weakSelf.UpdateTableBlock) {
                    weakSelf.UpdateTableBlock();
                }
            };
            self.uploadView.UpdateTableBlock = ^(NSString * _Nonnull recordText) {
                weakSelf.smallModel.yj_uploadAnswerText = recordText;
                if (weakSelf.UpdateTableBlock) {
                    weakSelf.UpdateTableBlock();
                }
            };
            self.uploadView.uploadVoiceBlock = ^(NSString * _Nonnull voiceUrl) {
                weakSelf.smallModel.yj_uploadAnswerUrl = voiceUrl;
            };
        }
        
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
- (NSString *)changeAnswerTypeWithCurrentType:(NSInteger)currentType toType:(NSInteger)toType{
    return [NSString stringWithFormat:@"切换为%@会删除%@，是否要切换？",[self toAnswerTypeTitle:toType],[self answerTypeTitle:currentType]];
}
- (NSString *)answerTypeTitle:(NSInteger)type{
    switch (type) {
        case 1:
            return @"图片内容";
        case 2:
            return @"录音内容";
        case 3:
            return @"上传内容";
        default:
            return @"文本内容";
    }
}
- (NSString *)toAnswerTypeTitle:(NSInteger)type{
    switch (type) {
        case 1:
            return @"图片作答";
        case 2:
            return @"录音作答";
        case 3:
            return @"上传作答";
        default:
            return @"文本作答";
    }
}
- (void)textAnswerClickAction{
    if (!self.textAnswerBtn.selected) {
        if (!IsArrEmpty(self.smallModel.yj_imgUrlArr) || !IsStrEmpty(self.smallModel.yj_recordAnswerText) || !IsStrEmpty(self.smallModel.yj_uploadAnswerText)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:[self changeAnswerTypeWithCurrentType:self.subjectAnswerType toType:0] cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_imgUrlArr = @[];
                    weakSelf.smallModel.yj_recordAnswerUrl = @"";
                    weakSelf.smallModel.yj_recordAnswerText = @"";
                    weakSelf.smallModel.yj_uploadAnswerUrl = @"";
                    weakSelf.smallModel.yj_uploadAnswerText = @"";
                    
                    weakSelf.subjectAnswerType = 0;
                    [weakSelf setContentBgVAnswerStyle];
                    weakSelf.addImageView.smallModel = (YJPaperSmallModel *)weakSelf.smallModel;
                    weakSelf.recordView.recordText = @"";
                    weakSelf.recordView.voiceUrl = @"";
                    weakSelf.uploadView.recordText = @"";
                    weakSelf.uploadView.voiceUrl = @"";
                    
                    if (weakSelf.UpdateTableBlock) {
                        weakSelf.UpdateTableBlock();
                    }
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                self.subjectAnswerType = 0;
                [self setContentBgVAnswerStyle];
            }];
        }
    }
}
- (void)imgAnswerClickAction{
    if (!self.imgAnswerBtn.selected) {
        if (!IsStrEmpty(self.smallModel.yj_smallAnswer) || !IsStrEmpty(self.smallModel.yj_recordAnswerText) || !IsStrEmpty(self.smallModel.yj_uploadAnswerText)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:[self changeAnswerTypeWithCurrentType:self.subjectAnswerType toType:1] cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_smallAnswer = @"";
                    weakSelf.smallModel.yj_recordAnswerUrl = @"";
                   weakSelf.smallModel.yj_recordAnswerText = @"";
                   weakSelf.smallModel.yj_uploadAnswerUrl = @"";
                   weakSelf.smallModel.yj_uploadAnswerText = @"";
                    
                     weakSelf.subjectAnswerType = 1;
                    [weakSelf setContentBgVAnswerStyle];
                    
                    weakSelf.recordView.recordText = @"";
                    weakSelf.recordView.voiceUrl = @"";
                    weakSelf.uploadView.recordText = @"";
                    weakSelf.uploadView.voiceUrl = @"";
                    
                    if (weakSelf.UpdateTableBlock) {
                        weakSelf.UpdateTableBlock();
                    }
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                 self.subjectAnswerType = 1;
                [self setContentBgVAnswerStyle];
            }];
        }
    }
}
- (void)recordAnswerClickAction{
    if (!self.recordAnswerBtn.selected) {
        if (!IsStrEmpty(self.smallModel.yj_smallAnswer) || !IsArrEmpty(self.smallModel.yj_imgUrlArr) || !IsStrEmpty(self.smallModel.yj_uploadAnswerText)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:[self changeAnswerTypeWithCurrentType:self.subjectAnswerType toType:2] cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_imgUrlArr = @[];
                    weakSelf.smallModel.yj_smallAnswer = @"";
                   weakSelf.smallModel.yj_uploadAnswerUrl = @"";
                   weakSelf.smallModel.yj_uploadAnswerText = @"";
                    
                     weakSelf.subjectAnswerType = 2;
                    [weakSelf setContentBgVAnswerStyle];
                    
                     weakSelf.addImageView.smallModel = (YJPaperSmallModel *)weakSelf.smallModel;
                
                    weakSelf.uploadView.recordText = @"";
                    weakSelf.uploadView.voiceUrl = @"";
                    
                    if (weakSelf.UpdateTableBlock) {
                        weakSelf.UpdateTableBlock();
                    }
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                 self.subjectAnswerType = 2;
                [self setContentBgVAnswerStyle];
            }];
        }
    }
}
- (void)uploadAnswerClickAction{
    if (!self.uploadAnswerBtn.selected) {
        if (!IsStrEmpty(self.smallModel.yj_smallAnswer) || !IsArrEmpty(self.smallModel.yj_imgUrlArr) || !IsStrEmpty(self.smallModel.yj_recordAnswerText)) {
            __weak typeof(self) weakSelf = self;
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:[self changeAnswerTypeWithCurrentType:self.subjectAnswerType toType:3] cancelTitle:@"否" destructiveTitle:@"是" cancelBlock:nil destructiveBlock:^{
                [UIView animateWithDuration:2.5 animations:^{
                    weakSelf.smallModel.yj_imgUrlArr = @[];
                    weakSelf.smallModel.yj_smallAnswer = @"";
                   weakSelf.smallModel.yj_recordAnswerUrl = @"";
                   weakSelf.smallModel.yj_recordAnswerText = @"";
                    
                     weakSelf.subjectAnswerType = 3;
                    [weakSelf setContentBgVAnswerStyle];
                    
                     weakSelf.addImageView.smallModel = (YJPaperSmallModel *)weakSelf.smallModel;
                    weakSelf.recordView.recordText = @"";
                    weakSelf.recordView.voiceUrl = @"";
                   
                    if (weakSelf.UpdateTableBlock) {
                        weakSelf.UpdateTableBlock();
                    }
                }];
            }] show];
        }else{
            [UIView animateWithDuration:2.5 animations:^{
                 self.subjectAnswerType = 3;
                [self setContentBgVAnswerStyle];
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
    
    self.memberTitleView.addable = editable;
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
    
    self.subjectAnswerType = 0;
    if (!IsArrEmpty(smallModel.yj_imgUrlArr) || self.imgAnswerBtn.selected) {
        self.subjectAnswerType = 1;
    }else if (!IsStrEmpty(smallModel.yj_recordAnswerText) || self.recordAnswerBtn.selected){
        self.subjectAnswerType = 2;
    }else if (!IsStrEmpty(smallModel.yj_uploadAnswerText) || self.uploadAnswerBtn.selected){
        self.subjectAnswerType = 3;
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
    }else{
         [self.answerBtnBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.photoBrowser.imageUrls = smallModel.yj_imgUrlArr;
    }

    self.recordView.recordText = smallModel.yj_recordAnswerText;
    self.recordView.voiceUrl = smallModel.yj_recordAnswerUrl;
    self.uploadView.recordText = smallModel.yj_uploadAnswerText;
    self.uploadView.voiceUrl = smallModel.yj_uploadAnswerUrl;
    self.uploadView.ownController = self.ownController;
    
    [self setContentBgVAnswerStyle];
}
- (void)invalidatePlayer{
    [self.recordView invalidatePlayer];
    [self.uploadView invalidatePlayer];
}
- (void)setContentBgVAnswerStyle{
    [self invalidatePlayer];
    
    self.smallModel.yj_subjectAnswerType = self.subjectAnswerType;
    
    self.contentBgV.hidden = self.subjectAnswerType != 0;
    self.imageBgV.hidden = self.subjectAnswerType != 1;
    self.recordView.hidden = self.subjectAnswerType != 2;
    self.uploadView.hidden = self.subjectAnswerType != 3;
    
    self.textAnswerBtn.selected = self.subjectAnswerType == 0;
    self.imgAnswerBtn.selected = self.subjectAnswerType == 1;
    self.recordAnswerBtn.selected = self.subjectAnswerType == 2;
    self.uploadAnswerBtn.selected = self.subjectAnswerType == 3;
    
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
- (UIButton *)recordAnswerBtn{
    if (!_recordAnswerBtn) {
        _recordAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_record_n" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_recordAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_record_s" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_recordAnswerBtn addTarget:self action:@selector(recordAnswerClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordAnswerBtn;
}
- (UIButton *)uploadAnswerBtn{
    if (!_uploadAnswerBtn) {
        _uploadAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_upload_n" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_uploadAnswerBtn setImage:[UIImage yj_imageNamed:@"yj_answer_upload_s" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_uploadAnswerBtn addTarget:self action:@selector(uploadAnswerClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadAnswerBtn;
}
- (YJMemberTitleView *)memberTitleView{
    if (!_memberTitleView) {
        _memberTitleView = [[YJMemberTitleView alloc] initWithFrame:CGRectZero];
    }
    return _memberTitleView;
}
- (YJSpeechRecordAnswerView *)recordView{
    if (!_recordView) {
        _recordView = [[YJSpeechRecordAnswerView alloc] initWithFrame:CGRectZero];
    }
    return _recordView;
}
- (YJSpeechUploadAnswerView *)uploadView{
    if (!_uploadView) {
        _uploadView = [[YJSpeechUploadAnswerView alloc] initWithFrame:CGRectZero];
    }
    return _uploadView;
}
@end
