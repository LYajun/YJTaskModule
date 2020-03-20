//
//  UIView+YJEmpty.h
//
//  Created by 刘亚军 on 2019/2/13.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YJEmpty)
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIView *viewTitleLoading;
@property (strong, nonatomic) UILabel *titleLoadingLab;
@property (strong, nonatomic) UIView *noDataView;
@property (strong, nonatomic) UILabel *noDataViewLab;
@property (strong, nonatomic) UIView *loadErrorView;
@property (strong, nonatomic) UILabel *loadErrorViewLab;
@property (nonatomic,copy) void (^updateDataBlock) (void);
- (void)yj_setViewLoadingShow:(BOOL)show;
- (void)yj_setViewTitleLoadingShow:(BOOL)show;
- (void)yj_setViewNoDataShow:(BOOL)show;
- (void)yj_setViewNoDataString:(NSString *)string;
- (void)yj_setViewLoadErrorShow:(BOOL)show;
- (void)yj_setViewLoadErrorString:(NSString *)string;
- (void)yj_setViewTitleLoadingString:(NSString *)string;
@end
