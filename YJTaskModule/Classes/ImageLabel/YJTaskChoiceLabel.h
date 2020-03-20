//
//  YJTaskChoiceLabel.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJImageLabel.h"

static CGFloat LabHeight = 30;
@interface YJTaskChoiceLabel : YJImageLabel
@property (nonatomic,assign) BOOL isChoiced;
@property (nonatomic,assign) BOOL isRight;
@property (nonatomic,assign) NSInteger index;
@end
