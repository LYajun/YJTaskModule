//
//  YJAppDelegate.m
//  YJTaskModule
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

#import "YJAppDelegate.h"
#import <YJTaskMark/YJSpeechMark.h>
#import <YJNetManager/YJNetMonitoring.h>
#import <YJTaskModule/YJConst.h>

@implementation YJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 网络监听 必须加 */
    [[YJSpeechManager defaultManager] initEngine];
    /** 语音评测 需要用到时才加 */
    [[YJNetMonitoring shareMonitoring] startNetMonitoring];
    
    /** 以下几个参数必须赋值，字符串可赋值为空 */
    [NSUserDefaults yj_setObject:@"用户ID" forKey:YJTaskModule_UserID_UserDefault_Key];
    [NSUserDefaults yj_setObject:@"用户类型" forKey:YJTaskModule_UserType_UserDefault_Key];
    [NSUserDefaults yj_setObject:@(YES) forKey:YJTaskModule_ImgAnswerEnable_UserDefault_Key];
    [NSUserDefaults yj_setObject:@"图片上传接口的Ip:Port" forKey:YJTaskModule_ApiUrl_UserDefault_Key];
    [NSUserDefaults yj_setObject:@"填空题是否支持语音识别" forKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
