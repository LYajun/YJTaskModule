//
//  YJWebViewController.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJWebViewController : UIViewController
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *fileUrl;
@property (nonatomic,copy) NSString *fileLocalPath;
@property (nonatomic,copy) NSString *ResFileExtension;


@property (nonatomic,copy) NSString *AssignmentID;


- (void)loadFileWithUrl:(NSString *)url;


/** 加载中 */
- (void)setViewLoadingShow:(BOOL)show;

/** 没有数据 */
@property (copy, nonatomic) NSString *textNoData;
- (void)setViewNoDataShow:(BOOL)show;

@property (copy, nonatomic) NSString *textLoadError;
- (void)setViewLoadErrorShow:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
