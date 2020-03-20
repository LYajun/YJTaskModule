//
//  YJSpeechSaveModel.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/13.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YJSpeechSaveWordModel : LGBaseModel
/** <#Annotations#> */
@property (nonatomic,copy) NSString *word;
/** <#Annotations#> */
@property (nonatomic,assign) float score;

@end

@interface YJSpeechSaveSentenceModel : LGBaseModel
/** <#Annotations#> */
@property (nonatomic,copy) NSString *sentence;
/** <#Annotations#> */
@property (nonatomic,assign) float score;

@property (nonatomic,strong) NSArray<YJSpeechSaveWordModel *> *words;
@end

@interface YJSpeechSaveScoreModel : LGBaseModel
/** 小题索引 */
@property (nonatomic,assign) NSInteger Tindex;
/** 总得分 */
@property (nonatomic,assign) float Tscore;
/** 韵律性信息得分 */
@property (nonatomic,assign) float Yscore;
/** 流利度得分 */
@property (nonatomic,assign) float Lscore;
/** 发音得分 */
@property (nonatomic,assign) float Zscore;
/** 完整度得分 */
@property (nonatomic,assign) float Wscore;
/** 标准答案 */
@property (nonatomic,copy) NSString *Ttruedetail;
/** 我的答案 */
@property (nonatomic,copy) NSString *Tdetail;
/** 评语 */
@property (nonatomic,copy) NSString *Comment;
/** 可不传 */
@property (nonatomic,copy) NSString *TOnceID;
/** 可不传 */
@property (nonatomic,copy) NSString *SubmissionTime;

/** 新增 - 缓存的录音文件名 */
@property (nonatomic,copy,readonly) NSString *speechName;
@property (nonatomic,copy,readonly) NSString *documentRelativePath;
@property (nonatomic,copy,readonly) NSString *documentSpeechPath;
@property (nonatomic,assign,readonly) BOOL isExistDocument;

@property (nonatomic,strong) NSArray<YJSpeechSaveSentenceModel *> *sentence;

- (void)downloadRecordFileWithCompletion:(void (^)(NSError *error))completion;
@end

@interface YJSpeechSaveModel : LGBaseModel
/** 学号 */
@property (nonatomic,copy) NSString *xh;
/** 任务ID */
@property (nonatomic,copy) NSString *AssignmentID;
/** 资料ID */
@property (nonatomic,copy) NSString *ResID;
/** 作答ID */
@property (nonatomic,copy) NSString *AnswerID;
/** 大题ID */
@property (nonatomic,copy) NSString *TopicID;
/** 大题题型ID */
@property (nonatomic,copy) NSString *TopicTypeID;
/** 大题题型名 */
@property (nonatomic,copy) NSString *TopicTypeName;

@property (nonatomic,strong) NSArray<YJSpeechSaveScoreModel *> *listScoreInfo;
@end

NS_ASSUME_NONNULL_END
