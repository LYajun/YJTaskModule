//
//  YJListenView.h
//
//
//  Created by 刘亚军 on 2017/3/5.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import "YJTaskBaseListenView.h"

@interface YJSlider : UISlider

@end

@class YJListenView;
@protocol YJListenViewDelegate <NSObject>

@optional
- (void)YJListenView:(YJListenView *)listenView currentPlayProgress:(CGFloat)progress totalDuration:(CGFloat)totalDuration;
- (void)didClickPlay;
- (void)finishPlay;
@end

@interface YJListenView : YJTaskBaseListenView



//xy添加
@property (nonatomic, assign) CGFloat allTime;

@property (nonatomic,assign) id<YJListenViewDelegate> delegate;



@end
