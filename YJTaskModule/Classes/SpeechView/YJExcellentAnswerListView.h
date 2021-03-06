//
//  YJExcellentAnswerListView.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJExcellentAnswerListView : UIView
@property (nonatomic,strong) NSArray *dataArr;
+ (YJExcellentAnswerListView *)excellentAnswerListView;
- (void)show;
@end

NS_ASSUME_NONNULL_END
