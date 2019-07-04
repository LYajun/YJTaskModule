//
//  YJListenListView.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/8/29.
//  Copyright © 2018年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJListenListView;
@protocol YJListenListViewDelegate <NSObject>

@optional
- (void)YJListenListView:(YJListenListView *) listView didSelectedItemAtIndex:(NSInteger) index;
- (void)YJListenListViewDidHide;
@end
@interface YJListenListView : UIView
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray<NSString *> *listenTitles;
@property (nonatomic,assign) id<YJListenListViewDelegate> delegate;
+ (YJListenListView *)showOnView:(UIView *) view frame:(CGRect) frame;
- (void) show;
@end
