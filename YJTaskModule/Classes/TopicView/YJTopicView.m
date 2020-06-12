//
//  YJTopicView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTopicView.h"
#import "YJTaskBaseListenView.h"
#import "YJMatchView.h"
#import "YJTopicTextView.h"
#import <Masonry/Masonry.h>
#import "YJWebViewController.h"
#import "YJCorrentView.h"
#import "YJConst.h"
#import <YJImageBrowser/YJImageBrowserView.h>

@interface YJTopicView ()<UITextViewDelegate,YJMatchViewDelegate>
@property (strong,nonatomic) YJTaskBaseListenView *listenView;
@property (strong,nonatomic) YJTopicTextView *textView;
@property (nonatomic,strong) YJWebViewController *readVC;
@property(nonatomic,strong) YJBasePaperBigModel *bigModel;
@property (strong,nonatomic) UILabel *titleL;
@property (assign,nonatomic) NSInteger currentSmallIndex;

@property (strong,nonatomic) YJCorrentView *correntView;
@end

@implementation YJTopicView
- (instancetype)initWithFrame:(CGRect)frame bigPModel:(YJBasePaperBigModel *)bigPModel{
    if (self = [super initWithFrame:frame]) {
        self.bigModel = bigPModel;
        [self configure];
        [self layoutUI];
    }
    return self;
}
- (void)configure{
    self.backgroundColor = [UIColor whiteColor];
    self.titleL.text = [self.bigModel.yj_bigTopicTypeName stringByAppendingFormat:@"[%@分]",self.bigModel.yj_bigScore];
    self.titleL.hidden = self.bigModel.yj_topicCarkMode;
    if (self.bigModel.yj_isCorrectTopic) {
        self.textView.scrollEnabled = NO;
        self.textView.text = self.bigModel.yj_correntTopicPintro;
        self.correntView.correntModel = self.bigModel.yj_correctModel;
        self.correntView.bigModel = (YJPaperBigModel *)self.bigModel;
    }else{
        self.textView.scrollEnabled = YES;
        self.textView.topicPintro = self.bigModel.yj_topicDirectionTxt;
        self.textView.topicContent = self.bigModel.yj_topicContent;
        if (self.bigModel.yj_bigTopicType == YJBigTopicTypeChioceBlank ||
            self.bigModel.yj_bigTopicType == YJBigTopicTypeBigTextAndBlank || [self.bigModel.yj_bigTopicTypeID isEqualToString:@"S"] || [self.bigModel.yj_bigTopicTypeID isEqualToString:@"U"]) {// 添加听力填空
            self.textView.topicIndexs = self.bigModel.yj_bigChioceBlankTopicIndexList;
            [self.textView setBlankAttributedString:self.bigModel.yj_bigTopicAttrText];
            self.textView.answerResults = self.bigModel.yj_bigChioceBlankAnswerList;
        }else{
            [self.textView setTopicContentAttr: self.bigModel.yj_bigTopicAttrText];
        }
    }
    self.listenView.urlNameArr = self.bigModel.yj_bigMediaNames;
    self.listenView.urlArr = self.bigModel.yj_bigMediaUrls;
}
- (void)layoutUI{
    [self layoutTitleView];
    switch (self.bigModel.yj_bigTopicType) {
        case YJBigTopicTypeListen:
            [self layoutListenView];
            break;
        case YJBigTopicTypeChioceBlank:
            if (IsStrEmpty(self.bigModel.yj_bigMediaUrl)) {
                [self layoutBigTopicContentView];
            }else{
                [self layoutListenAndBigTopicContentView];
            }
            break;
        case YJBigTopicTypeBigText:
        case YJBigTopicTypeBigTextAndBlank:
            [self layoutBigTopicContentView];
            break;
        case YJBigTopicTypeBigTextAndListen:
            [self layoutListenAndBigTopicContentView];
            break;
        default:
            [self layoutBigTopicContentView];
            break;
    }
}
- (void)layoutTitleView{
    NSString *sysID = [NSUserDefaults yj_stringForKey:YJTaskModule_SysID_UserDefault_Key];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        if (!IsStrEmpty(sysID) && [sysID isEqualToString:YJTaskModule_SysID_SpecialTraining]) {
            make.height.mas_equalTo(5);
        }else{
            if (self.bigModel.yj_topicCarkMode) {
                make.height.mas_equalTo(5);
            }else{
                make.height.mas_equalTo(36);
            }
        }
    }];
    
     if (!IsStrEmpty(sysID) && [sysID isEqualToString:YJTaskModule_SysID_SpecialTraining]) {
         self.titleL.hidden = YES;
     }
}
- (void)layoutListenView{
    [self addSubview:self.listenView];
    [self.listenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self);
        make.top.equalTo(self.titleL.mas_bottom);
        make.height.mas_equalTo(44);
    }];
}
- (void)layoutBigTopicContentView{
    if (self.bigModel.yj_topicCarkMode) {
        [self addSubview:self.readVC.view];
        [self.readVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.titleL.mas_bottom);
        }];
    }else{
        if (self.bigModel.yj_isCorrectTopic) {
            CGFloat height = 0;
            if (!IsStrEmpty(self.bigModel.yj_correntTopicPintro)) {
                CGSize stringSize = [self.bigModel.yj_correntTopicPintro boundingRectWithSize:CGSizeMake(LG_ScreenWidth-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
                height = stringSize.height + 20;
                if (height > 150) {
                    height = 150;
                }
            }
            [self addSubview:self.textView];
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.left.equalTo(self.mas_left).offset(5);
                make.top.equalTo(self.titleL.mas_bottom);
                make.height.mas_equalTo(height);
            }];
            [self addSubview:self.correntView];
            [self sendSubviewToBack:self.correntView];
            [self.correntView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(10);
                make.top.equalTo(self.textView.mas_bottom);
            }];
            [self.correntView yj_clipLayerWithRadius:0 width:1 color:LG_ColorThemeBlue];
        }else{
            [self addSubview:self.textView];
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(5);
                make.top.equalTo(self.titleL.mas_bottom);
            }];
        }
    }
}
- (void)layoutListenAndBigTopicContentView{
    [self addSubview:self.listenView];
    [self.listenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.titleL.mas_bottom).offset(self.bigModel.yj_topicCarkMode ? 10 : 0);
        make.height.mas_equalTo(44);
    }];
    if (self.bigModel.yj_topicCarkMode) {
        [self addSubview:self.readVC.view];
        [self.readVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(0);
            make.top.equalTo(self.listenView.mas_bottom).offset(5);
        }];
    }else{
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(5);
            make.top.equalTo(self.listenView.mas_bottom).offset(14);
        }];
    }
    
}
- (void)updateBlankAnswers{
    self.textView.answerResults = self.bigModel.yj_bigChioceBlankAnswerList;
}
- (void)startListen{
    if ([self isListen]) {
        [self.listenView startPlayer];
    }
}
- (void)pauseListen{
    if ([self isListen]) {
        [self.listenView pausePlayer];
    }
}
- (void)stopListen{
    if ([self isListen]) {
        [self.listenView stopPlayer];
    }
}
- (BOOL)isListen{
    if (self.bigModel.yj_bigTopicType == YJBigTopicTypeListen ||
        self.bigModel.yj_bigTopicType == YJBigTopicTypeBigTextAndListen) {
        return YES;
    }else{
        if (self.bigModel.yj_bigTopicType == YJBigTopicTypeChioceBlank && !IsStrEmpty(self.bigModel.yj_bigMediaUrl)) {
            return YES;
        }
        return NO;
    }
}
- (void)setHighlightSmallIndex:(NSInteger)highlightSmallIndex{
    _highlightSmallIndex = highlightSmallIndex;
    self.textView.currentSmallIndex = highlightSmallIndex;
}
- (void)setTaskStageType:(YJTaskStageType)taskStageType{
    _taskStageType = taskStageType;
    if (self.bigModel.yj_isCorrectTopic) {
        self.correntView.editable = (taskStageType == YJTaskStageTypeAnswer);
    }
}
- (void)showMatchViewByIndex:(NSInteger) index{
    BOOL isContain = NO;
    
    for (UIView *subview in LG_ApplicationWindow.subviews) {
        if ([subview isKindOfClass:[YJMatchView class]]) {
            isContain = YES;
            break;
        }
    }
    if (!isContain) {
        YJMatchView *matchView = [YJMatchView matchViewOnView:LG_ApplicationWindow frame:CGRectMake(0, LG_ApplicationWindow.height, LG_ScreenWidth, LG_ApplicationWindow.height*0.5)];
        YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[index];
        if (!IsStrEmpty(smallModel.yj_smallAnswer)) {
            matchView.editable = YES;
            matchView.currentIndex = smallModel.yj_smallAnswer.yj_stringToASCIIInt-65;
        }else{
            matchView.editable = NO;
        }
        matchView.topicContentArr = smallModel.yj_smallOptions;
        matchView.delegate = self;
        [matchView show];
    }
}

#pragma mark YJMatchView delegate
- (void)yj_matchView:(YJMatchView *)matchView didSelectedItemAtIndex:(NSInteger)index{
    [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.textView.answerResults];
    [arr replaceObjectAtIndex:self.currentSmallIndex withObject:[NSString yj_stringToASCIIStringWithIntCount:index+65]];
    self.textView.answerResults = arr;
    YJBasePaperSmallModel *smallModel = (YJBasePaperSmallModel *)self.bigModel.yj_smallTopicList[self.currentSmallIndex];
    smallModel.yj_smallAnswer = [NSString yj_stringToASCIIStringWithIntCount:index+65];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(yj_topicView:didClickBlankTextAtIndex:)]) {
        [self.delegate yj_topicView:self didClickBlankTextAtIndex:self.currentSmallIndex];
    }
}
#pragma mark UITextView delegate
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
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
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
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if (![textAttachment isKindOfClass:[YJTextAttachment class]]) {
        return NO;
    }
    NSInteger index = [(YJTextAttachment *)textAttachment textIndex];
    return [self yj_textView:textView didSelectTextIndex:index];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
    if (![textAttachment isKindOfClass:[YJTextAttachment class]]) {
        return NO;
    }
     NSInteger index = [(YJTextAttachment *)textAttachment textIndex];
    return [self yj_textView:textView didSelectTextIndex:index];
}
- (BOOL)yj_textView:(UITextView *)textView didSelectTextIndex:(NSInteger) index{
    self.highlightSmallIndex = index;
    // 匹配题容错
    if (self.bigModel.yj_bigChioceBlankAnswerList.count < self.textView.answerResults.count) {
        if (index > self.bigModel.yj_bigChioceBlankAnswerList.count - 1) {
            index = self.bigModel.yj_bigChioceBlankAnswerList.count - 1;
        }
    }
    
    self.currentSmallIndex = index;
    if (self.bigModel.yj_bigTopicType == YJBigTopicTypeChioceBlank) {
        if (self.taskStageType == YJTaskStageTypeAnswer) {
            [self showMatchViewByIndex:index];
        }else{
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(yj_topicView:didClickBlankTextAtIndex:)]) {
                [self.delegate yj_topicView:self didClickBlankTextAtIndex:index];
            }
        }
    }else{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(yj_topicView:didClickBlankTextAtIndex:)]) {
            [self.delegate yj_topicView:self didClickBlankTextAtIndex:index];
        }
    }
    return NO;
}

- (YJCorrentView *)correntView{
    if (!_correntView) {
        _correntView = [[YJCorrentView alloc] initWithFrame:CGRectZero];
    }
    return _correntView;
}
- (YJTaskBaseListenView *)listenView{
    if (!_listenView) {
        _listenView = [[[YJBasePaperBigModel taskListenViewClass] alloc] initWithFrame:CGRectZero];
    }
    return _listenView;
}
- (YJTopicTextView *)textView{
    if (!_textView) {
        _textView = [[YJTopicTextView alloc] initWithFrame:CGRectZero];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:LG_ColorWithHex(0x252525)};
    }
    return _textView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = LG_ColorWithHex(0x989898);
    }
    return _titleL;
}

- (YJWebViewController *)readVC{
    if (!_readVC) {
        _readVC = [[YJWebViewController alloc] init];
        _readVC.fileUrl = self.bigModel.yj_scantronHttp;
        _readVC.fileName = [self.bigModel.yj_scantronHttp componentsSeparatedByString:@"/"].lastObject;
        _readVC.ResFileExtension = [_readVC.fileName componentsSeparatedByString:@"."].lastObject;
        _readVC.AssignmentID = self.bigModel.yj_assignmentID;
    }
    return _readVC;
}
@end
