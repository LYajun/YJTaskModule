//
//  YJSpeechConfig.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/4/17.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechConfig : LGBaseModel
@property (nonatomic,copy) NSString *ServerID;
@property (nonatomic,copy) NSString *ServerName;
@property (nonatomic,copy) NSString *ServerIP;
@property (nonatomic,copy) NSString *ServerPort;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *UserPwd;
@property (nonatomic,copy) NSString *VirtualPath;

- (NSString *)ftpBasePath;

@end

NS_ASSUME_NONNULL_END
