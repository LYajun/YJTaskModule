//
//  YJSpeechSaveModel.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/13.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSpeechSaveModel.h"
#import "YJFileManager.h"
#import "YJConst.h"
#import <YJNetManager/YJNetManager.h>

@implementation YJSpeechSaveWordModel

@end
@implementation YJSpeechSaveSentenceModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"words":[YJSpeechSaveWordModel class]};
}
@end
@implementation YJSpeechSaveScoreModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"sentence":[YJSpeechSaveSentenceModel class]};
}
- (void)setTdetail:(NSString *)Tdetail{
    _Tdetail = Tdetail;
    _speechName = @"";
    if (!IsStrEmpty(Tdetail) && [Tdetail hasPrefix:@"http"]) {
        _speechName = [Tdetail componentsSeparatedByString:@"/"].lastObject;
        [self downloadRecordFileWithCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"缓存录音文件失败");
            }
        }];
    }
    
}
- (void)downloadRecordFileWithCompletion:(void (^)(NSError *error))completion{
     if (IsStrEmpty(self.Tdetail) || ![self.Tdetail hasPrefix:@"http"] || self.isExistDocument) {
         completion(nil);
     }
    NSString *path = self.documentSpeechPath;
    __weak typeof(self) weakSelf = self;
    [[YJNetManager defaultManager].setRequest(self.Tdetail) downloadCacheFileWithSuccess:^(id  _Nullable response) {
        if (IsStrEmpty(response)) {
            
            completion([NSError yj_errorWithCode:YJErrorValueNull description:@"音频下载失败"]);
        }else{
            NSString *toPath = path;
            if (weakSelf.isExistDocument) {
                [YJFileManager removeItemAtPath:response error:nil];
                completion(nil);
            }else{
                BOOL isOK = [YJFileManager moveItemAtPath:response toPath:toPath];
                if (isOK) {
                    completion(nil);
                }else{
                    completion([NSError yj_errorWithCode:YJErrorValueNull description:@"音频下载异常"]);
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        completion(error);
    }];
}
- (BOOL)isExistDocument{
    NSString *path = [self.documentRelativePath stringByAppendingPathComponent:self.speechName];
    BOOL isExist = [NSFileManager yj_fileIsExistOfPath:path];
    return isExist;
}
- (NSString *)documentSpeechPath{
    NSString *path = [self.documentRelativePath stringByAppendingPathComponent:self.speechName];
    return path;
}
- (NSString *)documentRelativePath{
    NSString *documentPath = [NSFileManager yj_documentsPath];
    NSString *userID = [NSUserDefaults yj_stringForKey:YJTaskModule_UserID_UserDefault_Key];
    return [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"downloadRecord/%@",userID]];
}
@end
@implementation YJSpeechSaveModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"listScoreInfo":[YJSpeechSaveScoreModel class]};
}
@end
