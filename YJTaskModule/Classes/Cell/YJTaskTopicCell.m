//
//  YJTaskTopicCell.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskTopicCell.h"
#import <Masonry/Masonry.h>
#import <YJExtensions/YJEHpple.h>
#import "YJConst.h"
#import <YJUtils/YJAudioPlayer.h>
#import <LGAlertHUD/LGAlertHUD.h>
#import <YJImageBrowser/YJImageBrowserView.h>
#import <YJExtensions/YJEGumbo+Query.h>

@interface YJTaskTopicTextView : UITextView
@end
@implementation YJTaskTopicTextView
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copy:)){
        return YES;
    }
    return NO;
}
@end

@interface YJTaskTopicCell ()<YJAudioPlayerDelegate,UITextViewDelegate>
@property (nonatomic,strong) YJTaskTopicTextView *textView;
@property (nonatomic,strong) YJAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIButton *voiceBtn;
@end
@implementation YJTaskTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}
- (void)layoutUI{
//    self.userInteractionEnabled = NO;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerX.bottom.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView);
        make.left.equalTo(self.textView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.voiceBtn.hidden = YES;
    if (IsIPad && CGAffineTransformIsIdentity(self.voiceBtn.transform)) {
        self.voiceBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.voiceBtn.transform = CGAffineTransformTranslate(self.voiceBtn.transform, 0, 2);
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidatePlayer) name:YJTaskModule_StopYJTaskTopicVoicePlay_Notification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setTopicText:(NSString *)topicText{
    _topicText = topicText;
    self.textView.text = topicText;
}
- (void)setTextAttr:(NSMutableAttributedString *)textAttr{
    _textAttr = textAttr;
    NSMutableAttributedString *attr = textAttr.mutableCopy;
    if (!IsStrEmpty(self.voiceUrl)) {
        [attr insertAttributedString:@"      ".yj_toMutableAttributedString atIndex:0];
    }
    
    [self obliquenessWithAttr:attr];
    
    [attr yj_setFont:17];
    [attr yj_setColor:LG_ColorWithHex(0x252525)];
    
    [self strongWithAttr:attr];
   
    if (!IsStrEmpty(self.topicContent) && ![self.topicContent containsString:@"style=\""]) {
        NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
        NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
        YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
        NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
        if (IsArrEmpty(tableArray)) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 8;
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
        }
    }
    self.textView.attributedText = attr;
}
- (void)strongWithAttr:(NSMutableAttributedString *)attr{
    if (!IsStrEmpty(self.topicContent) && [self.topicContent.lowercaseString containsString:@"<strong"]) {
           YJEGumboDocument *document = [[YJEGumboDocument alloc] initWithHTMLString:self.topicContent];
           NSArray *elements = document.Query(@"strong");
           for (YJEGumboElement *element in elements) {
               NSString *text = [element.text() yj_deleteWhitespaceAndNewlineCharacter];
               if (!IsStrEmpty(text)) {
                   NSString *textAttrStr = attr.string;
                   NSRange range = [textAttrStr rangeOfString:text];
                   if (range.location != NSNotFound) {
                       [attr yj_setBoldFont:17 atRange:range];
                       NSString *class = kApiParams(element.attr(@"class"));
                       if ([class isEqualToString:@"Ques-title"]) {
                           NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                           paragraphStyle.alignment = NSTextAlignmentCenter;
                           [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
                       }
                   }
               }
           }
       }
}
- (void)obliquenessWithAttr:(NSMutableAttributedString *)attr{
    YJEGumboDocument *document = [[YJEGumboDocument alloc] initWithHTMLString:self.topicContent];
       NSArray *elements1 = document.Query(@"i");
       NSArray *elements2 = document.Query(@"em");
       NSMutableArray *elements = [NSMutableArray array];
       if (!IsArrEmpty(elements1)) {
           [elements addObjectsFromArray:elements1];
       }
       if (!IsArrEmpty(elements2)) {
           [elements addObjectsFromArray:elements2];
          }
       for (YJEGumboElement *element in elements) {
           NSString *text = [element.text() yj_deleteWhitespaceAndNewlineCharacter];
           if (!IsStrEmpty(text)) {
               NSString *textAttrStr = attr.string;
               NSRange range = [textAttrStr rangeOfString:text];
               if (range.location != NSNotFound) {
                  [attr addAttribute:NSObliquenessAttributeName value:@(0.3) range:range];
               }
           }
       }
}

- (void)setVoiceUrl:(NSString *)voiceUrl{
    _voiceUrl = voiceUrl;
    self.voiceBtn.hidden = (IsStrEmpty(voiceUrl) ? YES : NO);
}
- (void)stopPlayVoice{
    [self.audioPlayer stop];
    self.voiceBtn.selected = NO;
}
- (void)invalidatePlayer{
    self.voiceBtn.selected = NO;
    [self.audioPlayer invalidate];
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
    self.voiceBtn.selected = YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSString *urlStr = URL.absoluteString;
    if (!IsStrEmpty(urlStr)) {
        urlStr = [urlStr stringByRemovingPercentEncoding];
        NSString *ext = [urlStr componentsSeparatedByString:@"."].lastObject;
        if (YJTaskSupportImgType(ext)) {
            [YJImageBrowserView showWithImageUrls:@[urlStr] atIndex:0];
        }
    }
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0) ){
     NSString *urlStr = URL.absoluteString;
     if (!IsStrEmpty(urlStr)) {
         urlStr = [urlStr stringByRemovingPercentEncoding];
         NSString *ext = [urlStr componentsSeparatedByString:@"."].lastObject;
         if (YJTaskSupportImgType(ext)) {
             [YJImageBrowserView showWithImageUrls:@[urlStr] atIndex:0];
         }
     }
    return NO;
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

- (YJTaskTopicTextView *)textView{
    if (!_textView) {
        _textView = [[YJTaskTopicTextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textColor = [UIColor darkGrayColor];
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:LG_ColorWithHex(0x252525)};
    }
    return _textView;
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
        [_voiceBtn setImage:[UIImage yj_imageNamed:@"kc_btn_video" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage yj_animatedImageNamed:@"kc_btn__video_gif" atDir:YJTaskBundle_Cell duration:1 atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(voiceAction) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn setImageEdgeInsets: UIEdgeInsetsMake(-6, -3, 0, 0)];
    }
    return _voiceBtn;
}
@end
