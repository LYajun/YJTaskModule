//
//  YJTaskChoiceCell.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@interface YJTaskChoiceCell : LGBaseTableViewCell
@property (nonatomic,assign) BOOL isChoiced;
@property (nonatomic,assign) BOOL isRight;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSMutableAttributedString *textAttr;

@property (nonatomic,assign) BOOL isHideIndexBgImg;
@end
