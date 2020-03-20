//
//  YJCorrectLab.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YJCorrectLab;
@protocol YJCorrectLabDelegate <NSObject>

@optional
- (void)remove:(YJCorrectLab *)lab;
- (void)removeAnswer:(YJCorrectLab *)lab;
- (void)correct:(YJCorrectLab *)lab;
- (void)preAdd:(YJCorrectLab *)lab;

@end

@interface YJCorrectLab : UILabel
@property (nonatomic,assign) BOOL isAnswer;
@property (nonatomic,assign) id<YJCorrectLabDelegate> delegate;

@property (nonatomic,copy) void (^tapBlock) (void);

- (void)removeAnswerLab;
@end

NS_ASSUME_NONNULL_END
