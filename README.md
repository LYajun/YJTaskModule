# YJTaskModule

[![CI Status](https://img.shields.io/travis/lyj/YJTaskModule.svg?style=flat)](https://travis-ci.org/lyj/YJTaskModule)
[![Version](https://img.shields.io/cocoapods/v/YJTaskModule.svg?style=flat)](https://cocoapods.org/pods/YJTaskModule)
[![License](https://img.shields.io/cocoapods/l/YJTaskModule.svg?style=flat)](https://cocoapods.org/pods/YJTaskModule)
[![Platform](https://img.shields.io/cocoapods/p/YJTaskModule.svg?style=flat)](https://cocoapods.org/pods/YJTaskModule)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YJTaskModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YJTaskModule'
```

## Usage

```ruby
#import <YJTaskMark/YJSpeechMark.h>
#import <YJNetManager/YJNetMonitoring.h>
#import <YJTaskModule/YJConst.h>


/** 网络监听 必须加 */
[[YJSpeechManager defaultManager] initEngine];
/** 语音评测 需要用到时才加 */
[[YJNetMonitoring shareMonitoring] startNetMonitoring];
    
/** 以下几个参数必须赋值，字符串可赋值为空 */
[NSUserDefaults yj_setObject:@"用户ID" forKey:YJTaskModule_UserID_UserDefault_Key];
[NSUserDefaults yj_setObject:@"用户类型" forKey:YJTaskModule_UserType_UserDefault_Key];
[NSUserDefaults yj_setObject:@"作文题是否支持图片作答" forKey:YJTaskModule_ImgAnswerEnable_UserDefault_Key];
[NSUserDefaults yj_setObject:@"图片上传接口的Ip:Port" forKey:YJTaskModule_ApiUrl_UserDefault_Key];
[NSUserDefaults yj_setObject:@"填空题是否支持语音识别" forKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
```

## Author

lyj, liuyajun1999@icloud.com

## License

YJTaskModule is available under the MIT license. See the LICENSE file for more info.
