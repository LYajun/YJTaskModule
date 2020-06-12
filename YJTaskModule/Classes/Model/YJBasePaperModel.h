//
//  YJBasePaperModel.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseModel.h"
#import "YJPaperProtocol.h"


NS_ASSUME_NONNULL_BEGIN
@class YJTaskCarkModel;
@interface YJBasePaperSmallModel : LGBaseModel<YJPaperSmallProtocol>
/** 简答题是否文本作答 */
@property (nonatomic,assign) BOOL yj_smallSimpleTextAnswer;
/** 单个答案 */
@property (nonatomic,copy) NSString *yj_smallAnswer;
/** 多个答案数组 */
@property (nonatomic,strong) NSArray *yj_smallAnswerArr;
/** 小题得分 */
@property (nonatomic,copy) NSString *yj_smallAnswerScore;

/** 图片数组*/
@property (nonatomic,strong) NSArray *yj_imgUrlArr;

- (void)updateSmallAnswerStr:(NSString *)answer atIndex:(NSInteger)index;
@end

@interface YJBasePaperBigModel : LGBaseModel<YJPaperBigProtocol>
/** 大题作答计时，大数据用 */
@property (nonatomic,assign) NSInteger yj_bigAnswerTimeCount;
@property (nonatomic,assign) NSInteger yj_bigAnswerTimeSum;
- (NSDictionary<NSString *,NSString *> *)choiceTopicInfo;
- (NSDictionary<NSString *,NSString *> *)blankTopicInfo;
- (NSDictionary<NSString *,NSString *> *)matchTopicInfo;
- (NSDictionary<NSString *,NSString *> *)listenTopicInfo;


+ (Class)taskListenViewClass;

- (Class)taskClassByTaskStageType:(YJTaskStageType)taskStageType;

- (Class)topicCardClassByTaskStageType:(YJTaskStageType)taskStageType;

- (Class)speechBigClassBySpeechBigTopicType:(YJSpeechBigTopicType)speechBigTopicType;
- (Class)speechViewerBigClassBySpeechBigTopicType:(YJSpeechBigTopicType)speechBigTopicType;

/** 是否为答题卡模式 */
@property (nonatomic,assign) BOOL yj_topicCarkMode;
/** 答题卡资料Http路径 */
@property (nonatomic,copy) NSString *yj_scantronHttp;
/** 答题卡资料音频Http路径 */
@property (nonatomic,copy) NSString *yj_scantronAudio;

/** 口语试题FTP本地相对路径 */
@property (nonatomic,copy) NSString *yj_ftpRelativePath;

/** 改错题作答答案数组 */
- (void)configCorrectAnswerInfo:(NSDictionary *)answerInfo;
@end

@interface YJBasePaperModel : LGBaseModel<YJPaperProtocol>
/** 作业是否提交 */
- (BOOL)yj_isSubmit;
/** 单次作答时间 */
@property (nonatomic,assign) NSInteger yj_answerTimeAdd;
/** 作业阶段类型 */
@property (nonatomic,assign) YJTaskStageType yj_taskStageType;
/** 当前大题索引 */
@property (nonatomic,assign) NSInteger yj_currentBigIndex;

/** 知识点信息显示开关 */
@property (nonatomic,assign) BOOL yj_taskKlgInfoDisplayEnable;
/** 是否教师分析阶段 */
@property (nonatomic,assign) BOOL yj_taskStageTypeTeachAnalysis;


- (NSInteger)quesMarkItemSum;
/** 已作答小题数 */
- (NSInteger)quesAnswerItemSum;
/** 已互评小题数 */
- (NSInteger)quesHpItemSum;
/** 作答小题数 */
- (NSInteger)quesItemSum;
/** 未作答第一道题的索引 */
- (NSIndexPath *)quesUnAnswerItemIndexPath;
/** 未评阅第一道题的索引 */
- (NSIndexPath *)quesUnMarkItemIndexPath;
- (NSArray<YJTaskCarkModel *> *)taskCarkModelArray;
- (NSArray<YJTaskCarkModel *> *)taskMarkCarkModelArray;
- (void)updateMutiBlankScoreInfo;
@end

NS_ASSUME_NONNULL_END
