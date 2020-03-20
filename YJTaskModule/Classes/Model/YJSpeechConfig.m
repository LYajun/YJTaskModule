//
//  YJSpeechConfig.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/4/17.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJSpeechConfig.h"

@implementation YJSpeechConfig
- (NSString *)ftpBasePath{
    return [NSString stringWithFormat:@"ftp://%@:%@",self.ServerIP,self.ServerPort];
}
@end
