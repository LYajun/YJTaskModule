//
//  YJWrittingImageView.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/28.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YJPaperSmallModel;
@interface YJWrittingImageView : UIView
@property (nonatomic,strong) YJPaperSmallModel *smallModel;
@property (nonatomic, copy) void(^updateImgBlock)(NSArray *imgUrls);
- (CGFloat)collectionViewItemWidth;
@end

NS_ASSUME_NONNULL_END
