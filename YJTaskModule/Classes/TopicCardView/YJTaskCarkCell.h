//
//  YJTaskCarkCell.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJTaskCarkModel;
@interface YJTaskCarkCell : UITableViewCell
@property (strong, nonatomic) UIImageView *curentImage;
@property (nonatomic,assign) BOOL bigTopicTypeNameHideBig;
@property (nonatomic,strong) YJTaskCarkModel *cardModel;
@property (nonatomic,copy) NSString *currentSmallIndexStr;
@property (nonatomic,assign) BOOL isTopicCardMode;
@property (nonatomic,assign) BOOL isManualMarkMode;
@property (nonatomic,copy) void (^SelectItemBlock) (NSInteger index);
@end
