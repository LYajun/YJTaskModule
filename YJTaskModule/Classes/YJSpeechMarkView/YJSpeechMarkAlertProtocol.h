//
//  YJSpeechMarkAlertProtocol.h
//  AFNetworking
//
//  Created by 刘亚军 on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YJSpeechMarkAlertProtocol <NSObject>
+ (void)showSpeechRecognizeView;
+ (void)dismiss;

@optional
+ (void)showSpeechMarkViewWithTitle:(NSString *)title;
+ (void)showSpeechMarkView;
@end

NS_ASSUME_NONNULL_END
