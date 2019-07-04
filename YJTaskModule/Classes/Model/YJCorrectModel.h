//
//  YJCorrectModel.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//[4]    (null)    @"GenreInfo" : 3 key/value pairs

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface YJCorrectAnswerInfoModel : LGBaseModel

@property (nonatomic,copy) NSString *Answer;
@property (nonatomic,assign) NSInteger Index;

@end


@interface YJCorrectTextInfoModel : LGBaseModel

@property (nonatomic,copy) NSString *Text;
@property (nonatomic,assign) NSInteger Index;

@end


@interface YJCorrectAnswerAreaModel : LGBaseModel

@property (nonatomic,copy) NSString *AnswerArea;
@property (nonatomic,assign) NSInteger Index;

@end


@interface YJCorrectGenreInfoModel : LGBaseModel

@property (nonatomic,copy) NSString *GenreID;
@property (nonatomic,copy) NSString *GenreName;
@property (nonatomic,assign) NSInteger GenreType;

@end



@interface YJCorrectModel : LGBaseModel

@property (nonatomic,strong) NSArray<YJCorrectAnswerInfoModel *> *ModelAnswerInfoList;

@property (nonatomic,strong) NSArray<YJCorrectTextInfoModel *> *ModelTextInfoList;

@property (nonatomic,strong) NSArray<YJCorrectAnswerAreaModel *> *ModelAnswerAreaList;

@property (nonatomic,strong) YJCorrectGenreInfoModel *GenreInfo;

@property (nonatomic,copy) NSString *QuesBrief;

/** 导语 */
@property (nonatomic,copy) NSString *QuesLeaderContent;

/** 大题题干 */
@property (nonatomic,copy) NSString *QuesBody;

/** 参考答案串 */
@property (nonatomic,copy) NSString *QuesAnswer;

/** 作答信息
 {
    key : 索引
    value : {
    @"type":"0-删除,1-修改,2-前增",
    @"start":"前面内容",
    @"text":"当前内容",
    @"answer":"作答内容", 0-删除，该值为空字符串
    @"end":"后面内容" 2-前增时，该值为空字符串
 }
 */
@property (nonatomic,copy) NSDictionary *QuesAnswerInfo;
@end

NS_ASSUME_NONNULL_END
