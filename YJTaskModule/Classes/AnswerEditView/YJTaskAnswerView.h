//
//  YJTaskAnswerView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/31.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTaskAnswerView : UIView

+ (instancetype)showWithText:(NSString *) text
           answerResultBlock:(void (^) (NSString *result)) answerResultBlock;
@end
