//
//  YJSpeechUploadAnswerView.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechUploadAnswerView : UIView
@property (nonatomic,weak) UIViewController *ownController;
@property (nonatomic,copy) NSString *recordText;
@property (nonatomic,copy) NSString *voiceUrl;
@property (nonatomic,copy) void (^UpdateTableBlock) (NSString *recordText);
@property (nonatomic,copy) void (^uploadVoiceBlock) (NSString *voiceUrl);
@property (nonatomic,copy) void (^removeRecordBlock) (void);
@property (nonatomic,copy) void (^playBlock) (void);
- (void)invalidatePlayer;
@end

NS_ASSUME_NONNULL_END
