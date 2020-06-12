//
//  YJMarkSubCell.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/29.
//  Copyright © 2019 刘亚军. All rights reserved.
//  主观题

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJMarkSubCell : LGBaseTableViewCell
@property (nonatomic,copy) NSString *topicContent;
/** 标题 */
@property (nonatomic,copy) NSString *titleStr;
/** 标题颜色 */
@property (nonatomic,strong) UIColor *titleColor;
/** 文本内容 */
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) NSAttributedString *textAttr;
@property (nonatomic,assign) BOOL isAddBgColor;

@property (nonatomic,strong) NSArray *imgUrlArr;
@end

NS_ASSUME_NONNULL_END
