//
//  YJTaskUnderlinedButton.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/24.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJTaskUnderlinedButton : UIButton
@property(nullable,nonatomic,copy) UIColor *lineColor;
@property(nonatomic,assign) CGFloat lineSpace;
@end

NS_ASSUME_NONNULL_END
