//
//  YJTaskTitleView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YJTaskMarqueeLabelType) {
    YJTaskMarqueeLabelTypeLeft = 0,//向左边滚动
    YJTaskMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

@interface YJTaskMarqueeLabel : UILabel

@property(nonatomic,assign) YJTaskMarqueeLabelType marqueeLabelType;
@property(nonatomic,assign) CGFloat speed;//速度
@property(nonatomic,assign) CGFloat secondLabelInterval;
@property(nonatomic,assign) NSTimeInterval stopTime;//滚到顶的停止时间
- (void)invalidateTimer;
@end



@interface YJTaskTitleView : UIView
@property(nonatomic,strong) UIButton *topicCarkBtn;
@property(nonatomic,copy) NSString *taskName;
@property(nonatomic,strong) NSAttributedString *topicIndexAttr;
@property (nonatomic,assign) BOOL carkable;
@property (nonatomic,assign) BOOL indexable;
@property (nonatomic,assign) BOOL botLineable;
@property(nonatomic,copy) void (^topicCardClickBlock) (void);
@end
