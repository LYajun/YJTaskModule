//
//  YJAnaDetailChoiceCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/25.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class YJBasePaperSmallModel;

@interface YJAnaDetailChoiceCell : LGBaseTableViewCell
/** 是否提交 */
@property (nonatomic,assign) BOOL isSubmit;
@property (nonatomic,strong) YJBasePaperSmallModel *smallModel;
@end
