//
//  YJTaskCarkView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJTaskCarkView,YJTaskCarkModel;
@protocol YJTaskCarkViewDelegate <NSObject>

@optional
- (void)yj_taskCarkView:(YJTaskCarkView *) cardView didSelectedItemAtIndexPath:(NSIndexPath *) indexPath;

@end

@interface YJTaskCarkView : UIView
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger currentSmallIndex;
@property (nonatomic,strong) NSArray<YJTaskCarkModel *> *dataArr;
@property (nonatomic,assign) BOOL isTopicCardMode;
@property (nonatomic,assign) BOOL bigTopicTypeNameHideBig;
@property (nonatomic,assign) id<YJTaskCarkViewDelegate> delegate;
+ (YJTaskCarkView *)taskCarkView;
- (void)show;
- (void)hide;
@end
