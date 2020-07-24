//
//  YJMemberListView.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YJMemberListView : UIView
@property (nonatomic,strong) NSArray *memberArr;

+ (YJMemberListView *)memberListView;
- (void)show;
@end

NS_ASSUME_NONNULL_END
