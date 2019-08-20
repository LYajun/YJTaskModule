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

@interface YJTaskWrittingCell ()
@property (nonatomic,strong) UILabel *indexLab;
@property (strong,nonatomic) LGBaseTextView *textView;
@property (strong,nonatomic) UIButton *recordBtn;
@property (strong, nonatomic) UIView *contentBgV;
@property (strong, nonatomic) UIView *imageBgV;

@property (strong,nonatomic) LGTPhotoBrowser *photoBrowser;
@property (strong,nonatomic) YJWrittingImageView *addImageView;
@end
@implementation YJTaskWrittingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.indexLab];
        [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(35);
        }];
        
        [self.contentView addSubview:self.imageBgV];
        [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-5);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.left.equalTo(self.indexLab.mas_right).offset(0);
            make.height.mas_equalTo([self.addImageView collectionViewItemWidth]);
        }];
        
        [self.imageBgV addSubview:self.addImageView];
        [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.top.equalTo(self.imageBgV);
            make.height.mas_equalTo([self.addImageView collectionViewItemWidth]);
        }];
        
        [self.contentView addSubview:self.contentBgV];
        [self.contentBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imageBgV.mas_top).offset(-5);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.left.equalTo(self.indexLab.mas_right).offset(0);
        }];
        
        BOOL isSpeechMarkEnable = [NSUserDefaults yj_boolForKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
        
        [self.contentBgV addSubview:self.recordBtn];
        [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentBgV).offset(0);
            make.right.equalTo(self.contentBgV).offset(0);
            make.width.height.mas_equalTo(isSpeechMarkEnable ? 35 : 0);
        }];
        
        self.recordBtn.hidden = !isSpeechMarkEnable;
        
        [self.contentBgV addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentBgV);
            make.top.equalTo(self.contentBgV);
            make.left.equalTo(self.contentBgV);
            make.bottom.equalTo(self.recordBtn.mas_top).offset(-4);
            make.height.mas_greaterThanOrEqualTo(44);
        }];
        [self.contentBgV yj_clipLayerWithRadius:4 width:1 color:LG_ColorWithHex(0x78beff)];
    }
    return self;
}
- (void)recordBtnLongTouchGes:(UILongPressGestureRecognizer *) longGes{
    if ([longGes state] == UIGestureRecognizerStateBegan) {
        [self.recordBtn setImage:[UIImage yj_imageNamed:@"yj_record_open" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [[YJSpeechManager defaultManager] startEngineAtRefText:nil markType:YJSpeechMarkTypeASR];
        [YJSpeechMarkView showSpeechMarkViewWithTitle:@"系统正在给你识别\n请稍候..."];
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
- (void)setAnswerStr:(NSString *)answerStr{
    _answerStr = answerStr;
    self.textView.text = answerStr;
    if (!self.editable) {
        if (IsStrEmpty(answerStr) && IsArrEmpty(self.smallModel.yj_imgUrlArr)) {
            answerStr = [NSString yj_Char1];
        }
        [self.recordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(IsStrEmpty(answerStr) ? 0: 35);
        }];
        [self.contentBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imageBgV.mas_top).offset(IsStrEmpty(answerStr) ? 44 : -5);
        }];
        self.contentBgV.hidden = IsStrEmpty(answerStr);
    }
}
- (void)setSmallModel:(YJPaperSmallModel *)smallModel{
    _smallModel = smallModel;
    self.addImageView.hidden = !self.editable;
    
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
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(isOffline ? 0 : [self.addImageView collectionViewItemWidth]);
        }];
    }else{
        if (IsArrEmpty(smallModel.yj_imgUrlArr)) {
            [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }else{
            CGFloat imageBgW = self.photoBrowserWidth;
            [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imageBgW/3);
            }];
            self.photoBrowser.imageUrls = smallModel.yj_imgUrlArr;
        }
    }
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
        _textView.maxLength = 1000;
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
