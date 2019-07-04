//
//  YJCorrentView.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YJCorrectModel,YJPaperBigModel;
@interface YJCorrentView : UIView
@property (nonatomic,strong) YJCorrectModel *correntModel;
@property (nonatomic,strong) YJPaperBigModel *bigModel;
@property (nonatomic,assign) BOOL editable;
@end

NS_ASSUME_NONNULL_END
