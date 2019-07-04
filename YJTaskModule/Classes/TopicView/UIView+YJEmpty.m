//
//  UIView+YJEmpty.m
//
//  Created by 刘亚军 on 2019/2/13.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIView+YJEmpty.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "LGActivityIndicatorView.h"
#import "YJConst.h"


@implementation UIView (YJEmpty)
- (void)yj_setViewLoadingShow:(BOOL)show{
    [self initLoadingView];
    [self.noDataView removeFromSuperview];
    [self.loadErrorView removeFromSuperview];
    [self.viewTitleLoading removeFromSuperview];
    [self setShowOnBackgroundView:self.loadingView show:show];
}
- (void)yj_setViewTitleLoadingShow:(BOOL)show{
    [self initTitleLoadingView];
    [self.loadingView removeFromSuperview];
    [self.loadErrorView removeFromSuperview];
    [self.noDataView removeFromSuperview];
    [self setShowOnBackgroundView:self.viewTitleLoading show:show];
}
- (void)yj_setViewNoDataShow:(BOOL)show{
    [self initNoDataView];
    [self.loadingView removeFromSuperview];
    [self.loadErrorView removeFromSuperview];
    [self.viewTitleLoading removeFromSuperview];
    [self setShowOnBackgroundView:self.noDataView show:show];
}
- (void)yj_setViewLoadErrorShow:(BOOL)show{
    [self initLoadErrorView];
    [self.loadingView removeFromSuperview];
    [self.noDataView removeFromSuperview];
    [self.viewTitleLoading removeFromSuperview];
    [self setShowOnBackgroundView:self.loadErrorView show:show];
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }else {
        [aView removeFromSuperview];
    }
}
- (void)yj_setViewNoDataString:(NSString *)string{
    [self initNoDataView];
    self.noDataViewLab.text = string;
}
- (void)yj_setViewLoadErrorString:(NSString *)string{
    [self initLoadErrorView];
    self.loadErrorViewLab.text = string;
}
- (void)yj_setViewTitleLoadingString:(NSString *)string{
    [self initTitleLoadingView];
    self.titleLoadingLab.text = string;
}
- (void)initLoadingView{
    if (!self.loadingView) {
        self.loadingView = [[UIView alloc]init];
        self.loadingView.backgroundColor = [UIColor whiteColor];
        LGActivityIndicatorView *activityIndicatorView = [[LGActivityIndicatorView alloc] initWithType:LGActivityIndicatorAnimationTypeBallPulse tintColor:LG_ColorWithHex(0x989898)];
        [self.loadingView addSubview:activityIndicatorView];
        [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.loadingView);
            make.width.height.mas_equalTo(100);
        }];
        [activityIndicatorView startAnimating];
    }
}
- (void)initTitleLoadingView{
    if (!self.viewTitleLoading) {
        self.viewTitleLoading = [[UIView alloc]init];
        self.viewTitleLoading.backgroundColor = [UIColor whiteColor];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.color = LG_ColorWithHex(0x45bcfa);
        self.titleLoadingLab = [[UILabel alloc] init];
        self.titleLoadingLab.font = [UIFont systemFontOfSize:16];
        self.titleLoadingLab.textAlignment = NSTextAlignmentCenter;
        self.titleLoadingLab.textColor =  LG_ColorWithHex(0x45bcfa);
        self.titleLoadingLab.text = @"正在上传作答结果...";
        [self.viewTitleLoading addSubview:self.titleLoadingLab];
        [self.titleLoadingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.viewTitleLoading);
            make.centerX.equalTo(self.viewTitleLoading).offset(12);
        }];
        [self.viewTitleLoading addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLoadingLab);
            make.right.equalTo(self.titleLoadingLab.mas_left).offset(-5);
        }];
        [indicatorView startAnimating];
    }
}
- (void)initNoDataView{
    if (!self.noDataView) {
        self.noDataView = [[UIView alloc]init];
        self.noDataView.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage yj_imageNamed:@"lg_statusView_empty" atDir:YJTaskBundle_Empty atBundle:YJTaskBundle()]];
        [self.noDataView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.noDataView);
            make.centerY.equalTo(self.noDataView).offset(-10);
        }];
        self.noDataViewLab = [[UILabel alloc] init];
        self.noDataViewLab.font = [UIFont systemFontOfSize:14];
        self.noDataViewLab.textAlignment = NSTextAlignmentCenter;
        self.noDataViewLab.textColor = LG_ColorWithHex(0x989898);
        self.noDataViewLab.text = @"数据为空";
        [self.noDataView addSubview:self.noDataViewLab];
        [self.noDataViewLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.noDataView);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
    }
}
- (void)initLoadErrorView{
    if (!self.loadErrorView) {
        self.loadErrorView = [[UIView alloc]init];
        self.loadErrorView.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage yj_imageNamed:@"lg_statusView_error" atDir:YJTaskBundle_Empty atBundle:YJTaskBundle()]];
        [self.loadErrorView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.loadErrorView);
            make.centerY.equalTo(self.loadErrorView).offset(-10);
        }];
        self.loadErrorViewLab = [[UILabel alloc]init];
        self.loadErrorViewLab.font = [UIFont systemFontOfSize:14];
        self.loadErrorViewLab.textAlignment = NSTextAlignmentCenter;
        self.loadErrorViewLab.textColor = LG_ColorWithHex(0x989898);
        self.loadErrorViewLab.text = @"操作失败，轻触刷新";
        [self.loadErrorView addSubview:self.loadErrorViewLab];
        [self.loadErrorViewLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(self.loadErrorView);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yj_againLoadData)];
        [self.loadErrorView addGestureRecognizer:tap];
    }
}
- (void)yj_againLoadData{
    if (self.updateDataBlock) {
        self.updateDataBlock();
    }
}
#pragma mark - runtime
- (UIView *)loadingView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLoadingView:(UIView *)loadingView{
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)viewTitleLoading{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setViewTitleLoading:(UIView *)viewTitleLoading{
    objc_setAssociatedObject(self, @selector(viewTitleLoading), viewTitleLoading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)titleLoadingLab{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTitleLoadingLab:(UILabel *)titleLoadingLab{
    objc_setAssociatedObject(self, @selector(titleLoadingLab), titleLoadingLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)noDataView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNoDataView:(UIView *)noDataView{
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)noDataViewLab{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNoDataViewLab:(UILabel *)noDataViewLab{
     objc_setAssociatedObject(self, @selector(noDataViewLab), noDataViewLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)loadErrorView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLoadErrorView:(UIView *)loadErrorView{
    objc_setAssociatedObject(self, @selector(loadErrorView), loadErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)loadErrorViewLab{
     return objc_getAssociatedObject(self, _cmd);
}
- (void)setLoadErrorViewLab:(UILabel *)loadErrorViewLab{
    objc_setAssociatedObject(self, @selector(loadErrorViewLab), loadErrorViewLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(void))updateDataBlock{
     return objc_getAssociatedObject(self, _cmd);
}
- (void)setUpdateDataBlock:(void (^)(void))updateDataBlock{
    objc_setAssociatedObject(self, @selector(updateDataBlock), updateDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
