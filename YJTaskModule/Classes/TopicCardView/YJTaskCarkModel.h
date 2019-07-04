//
//  YJTaskCarkModel.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJTaskCarkModel : NSObject
@property (nonatomic,copy) NSString *topcTypeName;
/** 大题索引 */
@property (nonatomic,assign) NSInteger topicIndex;
@property (nonatomic,strong) NSArray<NSNumber *> *answerResults;
/** 小题索引数组 */
@property (nonatomic,strong) NSArray<NSNumber *> *indexs;
@end
