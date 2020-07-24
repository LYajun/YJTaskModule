//
//  KYNativeAudio.m
//  KouyuDemo
//
//  Created by Attu on 2018/3/15.
//  Copyright © 2018年 Attu. All rights reserved.
//

#import "KYNativeAudio.h"

@interface KYNativeAudio()<NSStreamDelegate>

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation KYNativeAudio

- (void)feedAudioDataWith:(NSString *)audioPath {
    self.isRunning = YES;
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:audioPath];
    inputStream.delegate = self;
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream open];
}

- (void)stopRecorder {
    self.isRunning = NO;
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:{ // 读
            if(self.isRunning == YES) {
                uint8_t buf[1024];
                NSInputStream *reads = (NSInputStream *)aStream;
                NSInteger blength = [reads read:buf maxLength:sizeof(buf)];
                
                if (blength != 0) {
                    [self.delegate nativeAudioInputStream:buf bufferLength:(int)blength];
                } else {
                    self.isRunning = NO;
                    [aStream close];
                    [self.delegate nativeAudioFinishInputStream];
                }
            } else {
                [aStream close];
            }
            break;
        }
        case NSStreamEventErrorOccurred:{// 错误处理
            break;
        }
        case NSStreamEventEndEncountered: {
             if(self.isRunning == YES) {
                 self.isRunning = NO;
                 [aStream close];
                 [self.delegate nativeAudioFinishInputStream];
             }
            break;
        }
        case NSStreamEventNone:{// 无事件处理
            break;
        }
        case  NSStreamEventOpenCompleted:{// 打开完成
            break;
        }
        default:
            break;
    }
}

@end
