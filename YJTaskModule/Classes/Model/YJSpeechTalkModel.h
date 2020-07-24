//
//  YJSpeechTalkModel.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechTalkModel : LGBaseModel
@property (nonatomic,copy) NSString *Guid;
@property (nonatomic,copy) NSString *paperGuid;
@property (nonatomic,copy) NSString *topicID;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *userName;
/** 评论内容 */
@property (nonatomic,copy) NSString *evaluation;
@property (nonatomic,assign) NSInteger itemIndex;
/** 是否点赞，1为点赞，0为不点赞 */
@property (nonatomic,assign) NSInteger isGood;
/** 提交状态1为提交，0为未提交 */
@property (nonatomic,assign) NSInteger status;

+ (void)publishLikeWithParams:(NSDictionary *)params complete:(void (^ _Nullable) (NSError *_Nullable error))complete;
+ (void)publishTalkWithParams:(NSDictionary *)params complete:(void (^ _Nullable) (NSError *_Nullable error))complete;
@end

NS_ASSUME_NONNULL_END
