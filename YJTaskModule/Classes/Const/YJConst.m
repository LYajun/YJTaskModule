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

