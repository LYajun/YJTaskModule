//
//  YJSpeechTalkModel.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJSpeechTalkModel.h"
#import <YJNetManager/YJNetManager.h>
#import "YJConst.h"
#import <MJExtension/MJExtension.h>

@implementation YJSpeechTalkModel

+ (void)publishLikeWithParams:(NSDictionary *)params complete:(void (^)(NSError * _Nullable))complete{
    NSString *apiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *url = [apiUrl stringByAppendingString:@"/WebService.asmx/SubmitMutualEvaluation"];
    [[YJNetManager defaultManager].setRequest(url).setParameters(params).setRequestType(YJRequestTypePOST) startRequestWithSuccess:^(id  _Nonnull response) {
        if (response && [[response objectForKey:@"ReturnCode"] integerValue] == 1 && [[response objectForKey:@"Result"] boolValue]) {
             if (complete) {
                 complete(nil);
             }
        }else{
            if (complete) {
                complete([NSError yj_errorWithCode:YJErrorRequestFailed description:@"发布失败"]);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (complete) {
            complete(error);
        }
    }];
}
+ (void)publishTalkWithParams:(NSDictionary *)params complete:(void (^)(NSError * _Nullable))complete{
    NSString *apiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *url = [apiUrl stringByAppendingString:@"/WebService.asmx/SubmitMutualEvaluation"];
    [[YJNetManager defaultManager].setRequest(url).setParameters(params).setRequestType(YJRequestTypePOST) startRequestWithSuccess:^(id  _Nonnull response) {
        if (response && [[response objectForKey:@"ReturnCode"] integerValue] == 1 && [[response objectForKey:@"Result"] boolValue]) {
             if (complete) {
                 complete(nil);
             }
        }else{
            if (complete) {
                complete([NSError yj_errorWithCode:YJErrorRequestFailed description:@"发布失败"]);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (complete) {
            complete(error);
        }
    }];
}
@end
