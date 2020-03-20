//
//  ZH_BaseTableViewCell.h
//  LGEducationCenter
//
//  Created by 刘亚军 on 2017/3/20.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LGBaseTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isShowSeparator;
@property (nonatomic, assign) CGFloat separatorWidth;
@property (nonatomic, assign) CGFloat separatorOffset;
@property (nonatomic,strong) UIColor *sepColor;
@end
