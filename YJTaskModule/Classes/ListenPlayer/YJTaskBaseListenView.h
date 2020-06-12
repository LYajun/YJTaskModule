//
//  YJTaskBaseListenView.h
//  AFNetworking
//
//  Created by 刘亚军 on 2020/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJTaskBaseListenView : UIView
/** 音频地址数组 */
@property (nonatomic,strong) NSArray<NSString *> *urlArr;
@property (nonatomic,strong) NSArray<NSString *> *urlNameArr;
- (void)startPlayer;

- (void)pausePlayer;

- (void)stopPlayer;
@end

NS_ASSUME_NONNULL_END
