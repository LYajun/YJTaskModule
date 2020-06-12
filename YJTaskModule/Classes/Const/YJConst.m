//
//  YJConst.m
//  LGTeachingPlanFramework
//
//  Created by 刘亚军 on 2019/6/20.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJConst.h"


@interface YJBundleModel : NSObject

@end
@implementation YJBundleModel

@end

NSBundle *YJTaskBundle(void){
   return [NSBundle yj_bundleWithCustomClass:YJBundleModel.class bundleName:@"YJTaskModule"];
}
NSArray *YJTaskSupportImgTypes(void){
    return @[@"jpg",@"jpeg",@"png",@"bmp",@"gif"];
}
NSArray *YJTaskSupportTextTypes(void){
    return @[@"txt",@"doc",@"xls",@"ppt",@"wps",@"jpg",@"jpeg",@"png",@"bmp",@"gif",@"htm",@"url",@"pdf"];
}
NSArray *YJTaskSupportAudioTypes(void){
    return @[@"mp3",@"wav",@"wma",@"m4v",@"ogg",@"ape",@"au",@"aac",@"ra",@"mid"];
}
NSArray *YJTaskSupportVideoTypes(void){
    return @[@"mov",@"avi",@"mp4",@"rmvb",@"flv",@"3gp",@"mkv",@"wmv",@"mpg",@"mpeg",@"swf",@"rm"];
}
NSArray *YJTaskSupportResTypes(void){
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:YJTaskSupportTextTypes()];
    [arr addObjectsFromArray:YJTaskSupportAudioTypes()];
    [arr addObjectsFromArray:YJTaskSupportVideoTypes()];
    return arr;
}
BOOL YJTaskSupportImgType(NSString *ext){
    if (IsStrEmpty(ext)) {
        return NO;
    }
    for (NSString *resType in YJTaskSupportImgTypes()) {
        if ([resType.lowercaseString containsString:ext.lowercaseString] || [ext.lowercaseString containsString:resType.lowercaseString]) {
            return YES;
        }
    }
    return NO;
}
BOOL YJTaskSupportResType(NSString *ext){
    if (IsStrEmpty(ext)) {
        return NO;
    }
    for (NSString *resType in YJTaskSupportResTypes()) {
        if ([resType.lowercaseString containsString:ext.lowercaseString] || [ext.lowercaseString containsString:resType.lowercaseString]) {
            return YES;
        }
    }
    return NO;
}
BOOL YJTaskSupportTextType(NSString *ext){
    if (IsStrEmpty(ext)) {
        return NO;
    }
    for (NSString *resType in YJTaskSupportTextTypes()) {
        if ([resType.lowercaseString containsString:ext.lowercaseString] || [ext.lowercaseString containsString:resType.lowercaseString]) {
            return YES;
        }
    }
    return NO;
}
BOOL YJTaskSupportAudioType(NSString *ext){
    if (IsStrEmpty(ext)) {
        return NO;
    }
    for (NSString *resType in YJTaskSupportAudioTypes()) {
        if ([resType.lowercaseString containsString:ext.lowercaseString] || [ext.lowercaseString containsString:resType.lowercaseString]) {
            return YES;
        }
    }
    return NO;
}
BOOL YJTaskSupportVideoType(NSString *ext){
    if (IsStrEmpty(ext)) {
        return NO;
    }
    for (NSString *resType in YJTaskSupportVideoTypes()) {
        if ([resType.lowercaseString containsString:ext.lowercaseString] || [ext.lowercaseString containsString:resType.lowercaseString]) {
            return YES;
        }
    }
    return NO;
}
