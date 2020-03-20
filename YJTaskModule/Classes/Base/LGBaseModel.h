//
//  LGBaseModel.h
//  LancooProjectStructure
//
//  Created by 刘亚军 on 2017/8/8.
//  Copyright © 2017年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGBaseModel : NSObject<NSMutableCopying>
/** 用字典初始化（MJExtension） */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/** 用JSONString初始化 */
- (instancetype)initWithJSONString:(NSString *)aJSONString;

- (NSDictionary *)lg_JsonModel;
@end
