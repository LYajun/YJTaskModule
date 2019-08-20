//
//  YJListenView.m
//
//
//  Created by 刘亚军 on 2017/3/5.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import "YJListenView.h"
#import "YJListenPlayer.h"
#import "YJListenListView.h"

#import <LGAlertHUD/LGAlertHUD.h>
#import "YJProgressView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

 static CGFloat kYJSliderHeight = 3;
@implementation YJSlider
- (CGRect)trackRectForBounds:(CGRect)bounds{
   
    return CGRectMake(0, (self.bounds.size.height - kYJSliderHeight)/2, self.bounds.size.width, kYJSliderHeight);
}

@end

@interface YJListenView ()<YJListenPlayerDelegate,YJListenListViewDelegate>
{
    CGFloat _totalDuration;
}
@property (strong, nonatomic) UIButton *playBtn;
@property (nonatomic,strong) UILabel *currentPlayTimeL;
@property (nonatomic,strong) UILabel *timeSpaceLab;
@property (strong, nonatomic) UILabel *totalPlayTimeL;
@property (strong, nonatomic) YJProgressView *progressView;
@property (strong, nonatomic) YJSlider *playProgress;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UIView *listenBgView;
@property (strong,nonatomic) YJListenPlayer *listenPlayer;
@property (strong, nonatomic) UILabel *titleNameL;
@property (strong, nonatomic) UIButton *listenListBtn;

@property (nonatomic,assign) NSInteger currentIndex;

@property (copy,nonatomic) void (^BtnTapBlock) (void);
// 播放网上资源
@property (copy, nonatomic) NSString *urlString;
// 播放本地资源
@property (copy, nonatomic) NSString *path;
@property (nonatomic,assign) BOOL pauseByResign;

@end
@implementation YJListenView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{
  
    UIView *listenContentView = [UIView new];
    [self addSubview:listenContentView];
    [listenContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    
    [self addSubview:self.listenBgView];
    [self.listenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    listenContentView.layer.cornerRadius = 22;
    listenContentView.layer.shadowOpacity = 0.5;
    listenContentView.layer.shadowColor = LG_ColorWithHex(0x00C3F2).CGColor;
    listenContentView.layer.shadowOffset =  CGSizeMake(0, 2.0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(3, 2, LG_ScreenWidth-40-6, 44) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(22, 22)];
    listenContentView.layer.shadowPath = bezierPath.CGPath;
    
    [self.listenBgView yj_clipLayerWithRadius:22 width:0 color:nil];
    
    [self.listenBgView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listenBgView);
        make.left.equalTo(self.listenBgView).offset(20);
        make.height.width.mas_equalTo(30);
    }];
    
    self.playBtn.yj_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 0);
    
    [self.listenBgView addSubview:self.listenListBtn];
    [self.listenListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.listenBgView);
         make.right.equalTo(self.listenBgView).offset(-10);
         make.width.mas_equalTo(28);
         make.height.equalTo(self.listenListBtn.mas_width);
    }];
    [self.listenBgView addSubview:self.totalPlayTimeL];
    [self.totalPlayTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listenBgView);
        make.right.equalTo(self.listenListBtn.mas_left).offset(-10);
        make.width.mas_equalTo(38);
    }];
    [self.listenBgView addSubview:self.timeSpaceLab];
    [self.timeSpaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listenBgView);
        make.right.equalTo(self.totalPlayTimeL.mas_left).offset(0);
        make.width.mas_equalTo(5);
    }];
    [self.listenBgView addSubview:self.currentPlayTimeL];
    [self.currentPlayTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listenBgView);
        make.right.equalTo(self.timeSpaceLab.mas_left).offset(0);
        make.width.mas_equalTo(38);
    }];
    [self.listenBgView addSubview:self.playProgress];
    [self.playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listenBgView);
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.right.equalTo(self.currentPlayTimeL.mas_left).offset(-3);
    }];
    
    [self.listenBgView insertSubview:self.progressView belowSubview:self.playProgress];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.equalTo(self.playProgress);
        make.height.mas_equalTo(kYJSliderHeight);
    }];
    
    [self.progressView yj_clipLayerWithRadius:kYJSliderHeight/2 width:0 color:nil];
    
    [self.listenBgView addSubview:self.titleNameL];
    [self.titleNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.listenBgView);
        make.top.equalTo(self.listenBgView).offset(5);
    }];
    
    [self.listenBgView addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.listenBgView);
    }];
    
    [self indicatorViewStop];
    self.playProgress.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationWillResign:) name:UIApplicationWillResignActiveNotification object:nil];

}
- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ApplicationWillResign:(NSNotification *) noti{
    if (self.listenPlayer.isPlaying) {
        self.pauseByResign = YES;
        [self pausePlayer];
    }

}
- (void)stopPlayer{
    [self yj_listenPlayerDidPlayFinish];
}
- (void)pausePlayer{
    [self.listenPlayer pause];
    self.playBtn.selected = NO;
}

- (void)slideAction:(UISlider *)slide{
    [self.listenPlayer seekToTime:slide.value * _totalDuration];
}
- (void)setUrlArr:(NSArray<NSString *> *)urlArr{
    _urlArr = urlArr;
    if (IsArrEmpty(urlArr)) {
        return;
    }
    if (urlArr.count <= 1) {
        self.listenListBtn.hidden = YES;
        [self.listenListBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.titleNameL.hidden = YES;
    }else{
        self.listenListBtn.hidden = NO;
        [self.listenListBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(28);
        }];
        self.titleNameL.hidden = NO;
    }
    self.titleNameL.text = self.urlNameArr[self.currentIndex];
    NSString *url = self.urlArr[self.currentIndex];
    if ([url.lowercaseString hasPrefix:@"http"]) {
        self.urlString = url;
        self.path = nil;
    }else{
        self.path = url;
        self.urlString = nil;
    }
}
- (void)listenListClickAction:(UIButton *) btn{
    CGPoint relativePoint = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].origin;
    CGSize relativeSize = [self convertRect: self.bounds toView: [UIApplication sharedApplication].keyWindow].size;
    YJListenListView *listView = [YJListenListView showOnView:[UIApplication sharedApplication].keyWindow frame:CGRectMake(42, relativePoint.y+relativeSize.height, LG_ScreenWidth-84, (self.urlNameArr.count > 5 ? 5:self.urlNameArr.count)*44)];
    listView.delegate = self;
    listView.currentIndex = self.currentIndex;
    listView.listenTitles = self.urlNameArr;
    self.listenListBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}
- (void)buttonAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPlay)]) {
        [self.delegate didClickPlay];
    }
    if (!button.selected) {
        if (_totalDuration == 0) {
            [self indicatorViewStart];
            self.playProgress.userInteractionEnabled = NO;
            if (!IsStrEmpty(self.urlString)) {
                [self.listenPlayer setPlayerWithUrlString:self.urlString];
            }else if (!IsStrEmpty(self.path)){
                [self.listenPlayer setPlayerWithPath:self.path];
            }else{
                [self indicatorViewStop];
                [LGAlert showStatus:@"音频已损坏"];
            }
            
            __weak typeof(self) weakSelf = self;
            self.BtnTapBlock = ^{
                button.selected = YES;
                [weakSelf indicatorViewStop];
                weakSelf.playProgress.userInteractionEnabled = YES;
                if (![weakSelf.listenPlayer isPlaying]) {
                    [weakSelf.listenPlayer play];
                }
            };
        }else{
            button.selected = YES;
            if (![self.listenPlayer isPlaying]) {
                [self.listenPlayer play];
            }
        }
        
    }else{
        button.selected = NO;
        if ([self.listenPlayer isPlaying]) {
            [self.listenPlayer pause];
        }
    }
}
//- (void)pause{
//    [self buttonAction:self.playBtn];
//}
- (NSString *)timeWithInterVal:(float) interVal{
    int minute = interVal / 60;
    int second = (int)interVal % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
- (void)indicatorViewStop{
     [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}
- (void)indicatorViewStart{
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}
#pragma mark - YJListenListViewDelegate
- (void)YJListenListView:(YJListenListView *)listView didSelectedItemAtIndex:(NSInteger)index{
    self.currentIndex = index;
    _totalDuration = 0;
    [self yj_listenPlayerDidPlayFinish];
    NSString *url = self.urlArr[index];
    self.titleNameL.text = self.urlNameArr[index];
    if ([url.lowercaseString hasPrefix:@"http"]) {
        self.urlString = url;
        self.path = nil;
    }else{
        self.path = url;
        self.urlString = nil;
    }
    [self buttonAction:self.playBtn];
}
- (void)YJListenListViewDidHide{
    self.listenListBtn.imageView.transform = CGAffineTransformIdentity;
}
#pragma mark - YJListenPlayerDelegate
- (void)yj_listenPlayer:(YJListenPlayer *)player totalDuration:(CGFloat)totalDuration{
    _totalDuration = totalDuration;
    self.allTime = totalDuration;
    self.totalPlayTimeL.text = [self timeWithInterVal:totalDuration];
    if (!self.pauseByResign) {
        self.BtnTapBlock();
        self.pauseByResign = NO;
    }
}
- (void)yj_listenPlayer:(YJListenPlayer *)player totalBuffer:(CGFloat)totalBuffer{
    if (_totalDuration > 0) {
        self.progressView.progress = totalBuffer/_totalDuration;
    }
}
- (void)yj_listenPlayer:(YJListenPlayer *)player currentPlayProgress:(CGFloat)progress{
    self.playProgress.value = progress/_totalDuration;
    self.currentPlayTimeL.text = [self timeWithInterVal:progress];
    
    if (progress > 0 && self.delegate && [self.delegate respondsToSelector:@selector(YJListenView:currentPlayProgress:totalDuration:)]) {
        [self.delegate YJListenView:self currentPlayProgress:progress totalDuration:_totalDuration];
    }
}
- (void)yj_listenPlayerDidPlayFinish{
    self.playBtn.selected = NO;
    self.playProgress.value = 0;
    [self.listenPlayer stop];
    [self indicatorViewStop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishPlay)]) {
         [self.delegate finishPlay];
    }
}
- (void)yj_listenPlayerDidSeekFinish{
    self.playBtn.selected = YES;
    [self.listenPlayer play];
}
- (void)yj_listenPlayerDidPlayFail{
    [self indicatorViewStop];
    self.playBtn.selected = NO;
    self.playProgress.userInteractionEnabled = NO;
    [LGAlert showStatus:@"音频资源加载失败"];
    self.listenPlayer = nil;
}
#pragma mark - Getter
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage yj_imageNamed:@"lg_listen_play" atDir:YJTaskBundle_ListenView atBundle:YJTaskBundle()] forState:UIControlStateNormal];
         [_playBtn setImage:[UIImage yj_imageNamed:@"lg_listen_pause" atDir:YJTaskBundle_ListenView atBundle:YJTaskBundle()] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UILabel *)currentPlayTimeL{
    if (!_currentPlayTimeL) {
        _currentPlayTimeL = [UILabel new];
        _currentPlayTimeL.textColor = LG_ColorWithHex(0xcce7fe);
        _currentPlayTimeL.font = [UIFont systemFontOfSize:11];
        _currentPlayTimeL.textAlignment = NSTextAlignmentRight;
        _currentPlayTimeL.text = @"00:00";
    }
    return _currentPlayTimeL;
}
- (UILabel *)timeSpaceLab{
    if (!_timeSpaceLab) {
        _timeSpaceLab = [UILabel new];
        _timeSpaceLab.font = [UIFont systemFontOfSize:10];
        _timeSpaceLab.textColor = LG_ColorWithHex(0xcce7fe);
        _timeSpaceLab.textAlignment = NSTextAlignmentCenter;
        _timeSpaceLab.text = @"/";
    }
    return _timeSpaceLab;
}
- (UILabel *)totalPlayTimeL{
    if (!_totalPlayTimeL) {
        _totalPlayTimeL = [UILabel new];
        _totalPlayTimeL.textColor = LG_ColorWithHex(0xcce7fe);
        _totalPlayTimeL.font = [UIFont systemFontOfSize:11];
        _totalPlayTimeL.text = @"00:00";
    }
    return _totalPlayTimeL;
}
- (UILabel *)titleNameL{
    if (!_titleNameL) {
        _titleNameL = [UILabel new];
        _titleNameL.textColor = LG_ColorWithHex(0xcce7fe);
        _titleNameL.font = [UIFont systemFontOfSize:11];
        _titleNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleNameL;
}
- (YJProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[YJProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressTintColor = LG_ColorWithHex(0x068ed8);
        _progressView.trackTintColor = LG_ColorWithHex(0xcce7fe);
        _progressView.progress = 0;
    }
    return _progressView;
}
- (YJSlider *)playProgress{
    if (!_playProgress) {
        _playProgress = [[YJSlider alloc] initWithFrame:CGRectZero];
        [_playProgress setThumbImage:[UIImage yj_imageNamed:@"lg_listen_thumb" atDir:YJTaskBundle_ListenView atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        _playProgress.minimumTrackTintColor = [UIColor whiteColor];
        _playProgress.maximumTrackTintColor = [UIColor clearColor];
        _playProgress.value = 0;
        [_playProgress addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _playProgress;
}
- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}
- (UIView *)listenBgView{
    if (!_listenBgView) {
        _listenBgView = [UIView new];
        _listenBgView.backgroundColor = LG_ColorWithHex(0x0aa9fb);
    }
    return _listenBgView;
}
- (YJListenPlayer *)listenPlayer{
    if (!_listenPlayer) {
         _listenPlayer = [[YJListenPlayer alloc] init];
        _listenPlayer.delegate = self;
    }
    return _listenPlayer;
}
- (UIButton *)listenListBtn{
    if (!_listenListBtn) {
        _listenListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listenListBtn setImage:[UIImage yj_imageNamed:@"lg_listenlist_menu" atDir:YJTaskBundle_ListenView atBundle:YJTaskBundle()] forState:UIControlStateNormal];
        [_listenListBtn addTarget:self action:@selector(listenListClickAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _listenListBtn;
}
@end
