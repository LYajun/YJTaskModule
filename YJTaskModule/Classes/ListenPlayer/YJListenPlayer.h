//
//  YJListenPlayer.h
//  
//
//  Created by 刘亚军 on 2017/3/5.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@class YJListenPlayer;

@protocol YJListenPlayerDelegate <NSObject>
@optional
// 已经播放完毕时执行的方法
- (void)yj_listenPlayerDidPlayFinish;
// 获取总时长
- (void)yj_listenPlayer:(YJListenPlayer *) player totalDuration:(CGFloat) totalDuration;
// 获取总缓存时长
- (void)yj_listenPlayer:(YJListenPlayer *)player totalBuffer:(CGFloat) totalBuffer;
// 获取当前进度
- (void)yj_listenPlayer:(YJListenPlayer *) player currentPlayProgress:(CGFloat) progress;
// 在指定时间播放已准备好
- (void)yj_listenPlayerDidSeekFinish;
// 播放失败
- (void)yj_listenPlayerDidPlayFail;
@end
@interface YJListenPlayer : NSObject
// 播放音量
@property (nonatomic) float volume;
@property (nonatomic) id<YJListenPlayerDelegate> delegate;

// 播放
- (void)play;
// 暂停
- (void)pause;
// 停止
- (void)stop;
// 根据URL设置播放器
- (void)setPlayerWithUrlString:(NSString *) urlString;
- (void)setPlayerWithPath:(NSString *)path;
// 在指定时间播放
- (void)seekToTime:(CGFloat) time;
// 判断当前音乐是否正在播放
- (BOOL)isPlaying;
// 判断是否正在播放指定的音乐
- (BOOL)isPlayingWithUrl:(NSString *)urlString;
@end
