//
//  YJTaskWrittingView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTaskWrittingView : UIView
/** 标题 */
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *topicContent;
@property (nonatomic,strong) NSMutableAttributedString *topicInfoAttr;
@property (nonatomic,assign) BOOL isTopicCard;
+ (instancetype)showWithText:(NSString *) text
           answerResultBlock:(void (^) (NSString *result)) answerResultBlock;
@end
