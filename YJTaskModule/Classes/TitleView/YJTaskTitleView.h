//
//  YJTaskTitleView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTaskTitleView : UIView
@property(nonatomic,strong) UIButton *topicCarkBtn;
@property(nonatomic,copy) NSString *taskName;
@property(nonatomic,strong) NSAttributedString *topicIndexAttr;
@property (nonatomic,assign) BOOL carkable;
@property (nonatomic,assign) BOOL indexable;
@property (nonatomic,assign) BOOL botLineable;
@property(nonatomic,copy) void (^topicCardClickBlock) (void);
@end
