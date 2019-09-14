//
//  KYStartEngineConfig.m
//  KouyuDemo
//
//  Created by Attu on 2017/8/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "KYStartEngineConfig.h"

@implementation KYStartEngineConfig

//初始化默认参数
- (instancetype)init {
    self = [super init];
    if (self) {
        self.enable = YES;
        NSBundle *frameworkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[KYStartEngineConfig class]] pathForResource:@"YJTaskMark" ofType:@"bundle"]];
        NSString *frameworkPath = [frameworkBundle resourcePath];
        self.native = [frameworkPath stringByAppendingPathComponent:[[NSString alloc] initWithUTF8String:"native.res"]];
        self.provison = [frameworkPath stringByAppendingPathComponent:[[NSString alloc] initWithUTF8String:"skegn.provision"]];
        
/*
        self.native = [[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithUTF8String:"native.res"] ofType:NULL];
        
        //        self.provison = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"skegn.provision"];
        self.provison = [[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithUTF8String:"skegn.provision"] ofType:NULL];
        
*/
    }
    return self;
}


@end
