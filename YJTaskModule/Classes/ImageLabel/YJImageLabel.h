//
//  YJImageLabel.h
//
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJImageLabel : UIView
/** 背景图 */
@property (nonatomic,copy) NSString *bgImageName;
/** 字体大小 */
@property (nonatomic,assign) NSInteger fontSize;
/** 字体颜色 */
@property (nonatomic,strong) UIColor *textColor;
/** 文本内容 */
@property (nonatomic,copy) NSString *textStr;
@property (nonatomic,assign) BOOL isHideIndexBgImg;
@end
