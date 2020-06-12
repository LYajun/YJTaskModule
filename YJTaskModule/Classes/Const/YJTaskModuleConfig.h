//
//  YJTaskModuleConfig.h
//  AFNetworking
//
//  Created by 刘亚军 on 2020/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** 配置 */
static NSString *YJTaskModule_SysID_SpecialTraining = @"623";
static NSString *YJTaskModule_SysID_Exercise = @"510";
static NSString *YJTaskModule_SysID_Preview = @"630";
static NSString *YJTaskModule_SysID_TeachingMaterial = @"621";
static NSString *YJTaskModule_SysID_Multimedia = @"930";
static NSString *YJTaskModule_SysID_TeachingPlan = @"626";

static NSString *YJTaskModule_ImgApiUrl_UserDefault_Key = @"YJTaskModule_ImgApiUrl_UserDefault_Key";
static NSString *YJTaskModule_SysID_UserDefault_Key = @"YJTaskModule_SysID_UserDefault_Key";
static NSString *YJTaskModule_ListenClassName_UserDefault_Key = @"YJTaskModule_ListenClassName_UserDefault_Key";
static NSString *YJTaskModule_SpeechAlertClassName_UserDefault_Key = @"YJTaskModule_SpeechAlertClassName_UserDefault_Key";
static NSString *YJTaskModule_ApiUrl_UserDefault_Key = @"YJTaskModule_ApiUrl_UserDefault_Key";
static NSString *YJTaskModule_UserID_UserDefault_Key = @"YJTaskModule_UserID_UserDefault_Key";

static NSString *YJTaskModule_AssignmentID_UserDefault_Key = @"YJTaskModule_AssignmentID_UserDefault_Key";
static NSString *YJTaskModule_ResID_UserDefault_Key = @"YJTaskModule_ResID_UserDefault_Key";

static NSString *YJTaskModule_UserType_UserDefault_Key = @"YJTaskModule_UserType_UserDefault_Key";
static NSString *YJTaskModule_ImgAnswerEnable_UserDefault_Key = @"YJTaskModule_ImgAnswerEnable_UserDefault_Key";
static NSString *YJTaskModule_SpeechMarkEnable_UserDefault_Key = @"YJTaskModule_SpeechMarkEnable_UserDefault_Key";


@interface YJTaskModuleConfig : NSObject
/** 任务ID */
@property (nonatomic,copy) NSString *assignmentID;
/** 资料ID */
@property (nonatomic,copy) NSString *resID;
/** 系统ID */
@property (nonatomic,copy) NSString *sysID;
/** 听力播放器类名 */
@property (nonatomic,copy) NSString *listenClassName;
/** 语音评测弹窗类名 */
@property (nonatomic,copy) NSString *speechAlertClassName;
/** 图片上传Url基础地址 */
@property (nonatomic,copy) NSString *apiUrl;
/** 图片基础地址 */
@property (nonatomic,copy) NSString *imgApiUrl;
/** 用户ID */
@property (nonatomic,copy) NSString *userID;
/** 用户类型 */
@property (nonatomic,assign) NSInteger userType;
/** 是否支持图片作答,默认为NO */
@property (nonatomic,assign) BOOL imgAnswerEnable;
/** 是否支持语音作答,默认为NO*/
@property (nonatomic,assign) BOOL speechMarkEnable;

/** 保存配置信息 */
- (void)saveConfigInfo;

+ (NSString *)currentSysID;

@end

NS_ASSUME_NONNULL_END
