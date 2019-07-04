//
//  YJMatchView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJMatchView;
@protocol YJMatchViewDelegate <NSObject>

@optional
- (void)yj_matchView:(YJMatchView *) matchView didSelectedItemAtIndex:(NSInteger) index;

@end


@interface YJMatchView : UIView
@property (nonatomic,assign) BOOL editable;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray<NSMutableAttributedString *> *topicContentArr;
@property (nonatomic,assign) id<YJMatchViewDelegate> delegate;
+ (YJMatchView *)matchViewOnView:(UIView *) view frame:(CGRect) frame;
- (void)show;
@end
