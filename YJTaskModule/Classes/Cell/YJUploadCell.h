//
//  YJUploadCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
@interface YJMoreCell : UICollectionViewCell

@end

#pragma mark -

@interface YJUploadCell : UICollectionViewCell
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,assign) BOOL isBottom;
@property (nonatomic,assign) BOOL isForbidLongGes;

@property (nonatomic,assign) BOOL isCancelPanGes;
@property (nonatomic,copy) void (^deleteBlock) (void);
@property (nonatomic,copy) void (^deleteImgBlock) (UIImage *image);
- (void)setTaskImage:(UIImage *)taskImage;

@end
