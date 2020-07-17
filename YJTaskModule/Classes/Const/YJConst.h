//
//  TPFConst.h
//  LGTeachingPlanFramework
//
//  Created by 刘亚军 on 2019/6/20.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YJExtensions/YJExtensions.h>
#import "YJTaskModuleConfig.h"

// 屏幕尺寸
#define LG_ScreenWidth      [UIScreen mainScreen].bounds.size.width
#define LG_ScreenHeight     [UIScreen mainScreen].bounds.size.height
#define LG_AppDelegate      [UIApplication sharedApplication].delegate
#define LG_ApplicationWindow [UIApplication sharedApplication].delegate.window

// 颜色
#define LG_ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LG_ColorWithHexA(rgbValue,aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]

#define LG_SysFont(value) [UIFont systemFontOfSize:value]

// 常用颜色
#define LG_ColorThemeBlue          LG_ColorWithHex(0x1379EC)
#define LG_ColorLightGray          LG_ColorWithHex(0xEDEDED)

#define kYJTextFontSize 17
#define kYJTextLineSpacing 6
//是否为空
#define kApiParams(_ref)    (IsObjEmpty(_ref) ? @"" : _ref)
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
#define IsObjEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


static NSString *YJTaskModule_StopYJTaskTopicVoicePlay_Notification = @"YJTaskModule_StopYJTaskTopicVoicePlay_Notification";
static NSString *YJTaskModule_KlgAlert_Notification = @"YJTaskModule_KlgAlert_Notification";


static NSString *YJTaskBundle_Cell = @"Cell";
static NSString *YJTaskBundle_Empty = @"EmptyPage";
static NSString *YJTaskBundle_ListenView = @"ListenView";
static NSString *YJTaskBundle_SpeechAnswer = @"SpeechAnswer";

NSBundle *YJTaskBundle(void);


static NSString *YJTaskModule_u2060 = @"\u2060";
static NSString *YJTaskModule_u2063 = @"\u2063";
static NSString *YJTaskModule_x2063 = @"&#x2063;";

NSArray *YJTaskSupportTextTypes(void);
NSArray *YJTaskSupportAudioTypes(void);
NSArray *YJTaskSupportVideoTypes(void);
NSArray *YJTaskSupportResTypes(void);
BOOL YJTaskSupportResType(NSString *ext);
BOOL YJTaskSupportTextType(NSString *ext);
BOOL YJTaskSupportAudioType(NSString *ext);
BOOL YJTaskSupportVideoType(NSString *ext);
BOOL YJTaskSupportImgType(NSString *ext);
