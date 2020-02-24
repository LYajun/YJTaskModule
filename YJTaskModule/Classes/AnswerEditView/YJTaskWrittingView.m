//
//  YJTaskWrittingView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskWrittingView.h"
#import "LGBaseTextView.h"
#import <Masonry/Masonry.h>
#import <YJResizableSplitView/YJResizableSplitView.h>
#import <TFHpple/TFHpple.h>
#import "YJConst.h"
#import <LGAlertHUD/LGAlertHUD.h>

#define kTopicHeight 80
@interface YJTaskWrittingView ()<LGBaseTextViewDelegate,YJResizableSplitViewDelegate>
@property (nonatomic,strong) LGBaseTextView *textView;
@property (nonatomic,copy) void (^answerResultBlock) (NSString *result);

@property (nonatomic,strong) UITextView *topicTextView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) YJResizableSplitView *splitView;
/** 是否发生更改 */
@property (nonatomic,assign) BOOL isUpdate;
@end
@implementation YJTaskWrittingView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layouyUI];
    }
    return self;
}
- (void)layouyUI{
    UIView *navBar = [UIView new];
    [self addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo([self yj_customNavBarHeight]);
    }];
     [navBar yj_setGradientBackgroundWithColors:@[LG_ColorWithHex(0x04caf4),LG_ColorWithHex(0x23a1fa)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = 1;
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = LG_SysFont(15);
    [backBtn addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBar.mas_top).offset(28 + [self yj_stateBarSpace]);
        make.left.equalTo(navBar.mas_left).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
    }];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.tag = 2;
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = LG_SysFont(15);
    [sureBtn addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBar.mas_top).offset(28+[self yj_stateBarSpace]);
        make.right.equalTo(navBar.mas_right).offset(-10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
    }];
    
    UILabel *titleL = [UILabel new];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"作文题";
    self.titleLab = titleL;
    [navBar addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navBar);
        make.bottom.equalTo(navBar.mas_bottom).offset(-13);
        make.left.equalTo(backBtn.mas_right).offset(10);
    }];
    
    [self addSubview:self.topicTextView];
    [self.topicTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBar.mas_bottom);
        make.centerX.equalTo(self);
        make.left.equalTo(self.mas_left).offset(8);
        make.height.mas_equalTo(kTopicHeight);
    }];
    
    
    [self addSubview:self.splitView];
    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topicTextView.mas_bottom);
    }];
    
    [self.splitView.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.top.equalTo(self.splitView.contentView);
        make.bottom.equalTo(self.splitView.contentView).offset(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWillDidBeginEditingNoti:) name:LGUITextViewWillDidBeginEditingCursorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWillDidEndEditingNoti:) name:LGUITextViewWillDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNoti) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:@"YJAnswerTimerDidFinishCountdown" object:nil];
}
+ (instancetype)showWithText:(NSString *)text answerResultBlock:(void (^)(NSString *))answerResultBlock{
    YJTaskWrittingView *writtingView = [[YJTaskWrittingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    writtingView.answerResultBlock = answerResultBlock;
    writtingView.textView.text = text;
    [writtingView show];
    return writtingView;
}
#pragma mark NSNotification action
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterBackgroundNoti{
    [self endEditing:YES];
}

- (void)textViewWillDidBeginEditingNoti:(NSNotification *) noti{
    NSDictionary *info = noti.userInfo;
    CGFloat overstep = [[info objectForKey:@"offset"] floatValue];
    self.splitView.bottomDistance = overstep + 64;
    if (LG_ScreenHeight-[self yj_customNavBarHeight] - self.topicTextView.height < self.splitView.bottomDistance) {
        [self.topicTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(LG_ScreenHeight-[self yj_customNavBarHeight] - self.splitView.bottomDistance);
        }];
    }
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.splitView.contentView).offset(-overstep);
    }];
}
- (void)textViewWillDidEndEditingNoti:(NSNotification *) noti{
    self.splitView.bottomDistance = 140;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.splitView.contentView).offset(0);
    }];
}
#pragma mark - LGBaseTextViewDelegate
- (void)yj_textViewDidChange:(LGBaseTextView *)textView{
    self.isUpdate = YES;
}
#pragma mark - YJResizableSplitViewDelegate
- (void)YJResizableSplitViewBeginEditing:(YJResizableSplitView *)resizableSplitView{
    
}
- (void)YJResizableSplitViewDidBeginEditing:(YJResizableSplitView *)resizableSplitView{
    CGFloat height = LG_ScreenHeight-[self yj_customNavBarHeight] - CGRectGetHeight(resizableSplitView.frame);
    [self.topicTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}
- (void)YJResizableSplitViewDidEndEditing:(YJResizableSplitView *)resizableSplitView{
    
}
- (void)setIsTopicCard:(BOOL)isTopicCard{
    _isTopicCard = isTopicCard;
    [self.topicTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(isTopicCard ? 0:kTopicHeight);
    }];
    self.splitView.dragEnable = !isTopicCard;
}
- (void)setTopicInfoAttr:(NSMutableAttributedString *)topicInfoAttr{
    _topicInfoAttr = topicInfoAttr;
    NSMutableAttributedString *attr = topicInfoAttr.mutableCopy;
    [attr yj_setFont:17];
    [attr yj_setColor:LG_ColorWithHex(0x252525)];
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
    if (IsArrEmpty(tableArray)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    }
    self.topicTextView.attributedText = attr;
}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    
    [self.textView becomeFirstResponder];
}
- (void)creatShowAnimation{
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
- (void)hide:(UIButton *)btn{
    [self.textView resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    if (btn.tag == 2 && self.answerResultBlock) {
        NSString *text = self.textView.text;
        if (!IsStrEmpty(text) && IsStrEmpty([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])) {
            text = @"";
        }
        self.answerResultBlock(text);
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }else{
        if (btn.tag == 1 && self.isUpdate) {
            [[YJLancooAlert lancooAlertWithTitle:@"温馨提示" msg:@"点击取消会丢失已更改的作答内容" cancelTitle:@"我再想想" destructiveTitle:@"取消" cancelBlock:^{
            } destructiveBlock:^{
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
            }] show];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
    }
}
- (YJResizableSplitView *)splitView{
    if (!_splitView) {
        _splitView = [[YJResizableSplitView alloc] initWithFrame:CGRectZero];
        _splitView.delegate = self;
        _splitView.topDistance =  [self yj_customNavBarHeight] + 44;
        _splitView.bottomDistance =  140;
    }
    return _splitView;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [[LGBaseTextView alloc] initWithFrame:CGRectZero];
        [_textView setAutoCursorPosition:YES];
//        _textView.assistHeight = 40;
        _textView.placeholder = @"请输入...";
//        _textView.maxLength = 1000;
        _textView.font = LG_SysFont(17);
        _textView.limitType = YJTextViewLimitTypeEmojiLimit;
    }
    return _textView;
}
- (UITextView *)topicTextView{
    if (!_topicTextView) {
        _topicTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _topicTextView.editable = NO;
        _topicTextView.selectable = NO;
        _topicTextView.font = LG_SysFont(18);
        _topicTextView.textColor = [UIColor darkGrayColor];
    }
    return _topicTextView;
}
@end
