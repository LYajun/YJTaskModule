//
//  YJTaskModuleConfig.m
//  AFNetworking
//
//  Created by 刘亚军 on 2020/4/22.
//

#import "YJTaskModuleConfig.h"
#import <YJExtensions/YJExtensions.h>
#import "YJConst.h"

@implementation YJTaskModuleConfig


- (void)saveConfigInfo{
    
    [NSUserDefaults yj_setObject:kApiParams(self.apiUrl) forKey:YJTaskModule_ApiUrl_UserDefault_Key];
    [NSUserDefaults yj_setObject:kApiParams(self.imgApiUrl) forKey:YJTaskModule_ImgApiUrl_UserDefault_Key];
    [NSUserDefaults yj_setObject:kApiParams(self.userID) forKey:YJTaskModule_UserID_UserDefault_Key];
    [NSUserDefaults yj_setObject:kApiParams(self.sysID) forKey:YJTaskModule_SysID_UserDefault_Key];
    
    [NSUserDefaults yj_setObject:kApiParams(self.assignmentID) forKey:YJTaskModule_AssignmentID_UserDefault_Key];
    [NSUserDefaults yj_setObject:kApiParams(self.resID) forKey:YJTaskModule_ResID_UserDefault_Key];
    
    [NSUserDefaults yj_setObject:kApiParams(self.listenClassName) forKey:YJTaskModule_ListenClassName_UserDefault_Key];
     [NSUserDefaults yj_setObject:kApiParams(self.speechAlertClassName) forKey:YJTaskModule_SpeechAlertClassName_UserDefault_Key];
    [NSUserDefaults yj_setObject:@(self.userType) forKey:YJTaskModule_UserType_UserDefault_Key];
    [NSUserDefaults yj_setObject:@(self.imgAnswerEnable) forKey:YJTaskModule_ImgAnswerEnable_UserDefault_Key];
    [NSUserDefaults yj_setObject:@(self.speechMarkEnable) forKey:YJTaskModule_SpeechMarkEnable_UserDefault_Key];
    
}

+ (NSString *)currentSysID{
    NSString *sysID = [NSUserDefaults yj_stringForKey:YJTaskModule_SysID_UserDefault_Key];
    return sysID;
}

@end
