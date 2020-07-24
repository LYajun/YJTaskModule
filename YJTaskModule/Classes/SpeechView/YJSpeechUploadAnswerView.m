//
//  YJSpeechUploadAnswerView.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechUploadAnswerView.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>
#import "YJSpeechRecordResultView.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import <YJTaskMark/YJSpeechManager.h>

@interface YJSpeechUploadAnswerView ()<UIDocumentPickerDelegate>
@property (nonatomic,strong) UILabel *tipLab;
@property (nonatomic,strong) UIButton *uploadBtn;
@property (nonatomic,strong) YJSpeechRecordResultView *resultView;
@end
@implementation YJSpeechUploadAnswerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    
 [self addSubview:self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(10);
        make.height.mas_equalTo(28);
    }];
    
    [self addSubview:self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.uploadBtn.mas_top).offset(0);
    }];

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

- (void)setRecordText:(NSString *)recordText{
    _recordText = recordText;
    self.resultView.recordText = recordText;
    self.resultView.hidden = IsStrEmpty(recordText);
    self.uploadBtn.hidden = !self.resultView.hidden;
    self.tipLab.hidden = !self.resultView.hidden;
}
- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    self.resultView.voiceUrl = voiceUrl;
}
- (void)invalidatePlayer{
    [self.resultView invalidatePlayer];
}
- (void)uploadAction{
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc]
                                                            initWithDocumentTypes:@[@"public.audio"] inMode:UIDocumentPickerModeImport];
      documentPicker.delegate = self;
      documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
      [self.ownController presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (!IsArrEmpty(urls)) {
        NSString *voiceUrl = urls.firstObject.path;
        NSTimeInterval voiceDuration = YJTaskAudioDurationFromURL(voiceUrl);
        if (voiceDuration > 180) {
             [LGAlert showInfoWithStatus:@"音频时长已超上限(180s)"];
        }else{
            NSString *ext = voiceUrl.pathExtension;
            if (YJTaskSupportAudioType(ext)) {
                if (self.uploadVoiceBlock) {
                    self.uploadVoiceBlock(voiceUrl);
                }
                [LGAlert showIndeterminateWithStatus:@"语音识别中..."];
                [[YJSpeechManager defaultManager] startEngineAtRefText:voiceUrl markType:YJSpeechMarkTypeASR fileASR:YES];
            }else{
                [LGAlert showInfoWithStatus:@"该格式文件不支持"];
            }
        }
    }else{
        [LGAlert showInfoWithStatus:@"文件选取失败"];
    }
    
}

- (YJSpeechRecordResultView *)resultView{
    if (!_resultView) {
        _resultView = [[YJSpeechRecordResultView alloc] initWithFrame:CGRectZero];
    }
    return _resultView;
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [UILabel new];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.textColor = LG_ColorWithHex(0x989898);
        _tipLab.font = LG_SysFont(15);
        _tipLab.text = @"暂无作答内容";
    }
    return _tipLab;
}
- (UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadBtn.titleLabel.font = LG_SysFont(15);
        [_uploadBtn setTitle:@"添加音频文件" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:LG_ColorWithHex(0x5BCAFC) forState:UIControlStateNormal];
        [_uploadBtn setImage:[UIImage yj_imageNamed:@"add_record" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
        [_uploadBtn yj_setImagePosition:YJImagePositionLeft spacing:4];
    }
    return _uploadBtn;
}
@end
