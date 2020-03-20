//
//  YJPaperProtocol.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *UserDefaults_YJAnswerStatusChanged = @"UserDefaults_YJAnswerStatusChanged";
static NSString *UserDefaults_YJHpStatusChanged = @"UserDefaults_YJHpStatusChanged";
static NSString *UserDefaults_YJCheckStatusChanged = @"UserDefaults_YJCheckStatusChanged";

static NSString *UserDefaults_YJAnswerSpeed = @"UserDefaults_YJAnswerSpeed";

static NSString *UserDefaults_YJTaskStageType = @"UserDefaults_YJTaskStageType";

static NSString *UserDefaults_YJTaskOfflineAssignmentID = @"UserDefaults_YJTaskOfflineAssignmentID";
static NSString *UserDefaults_YJAnswerOfflineStatus = @"UserDefaults_YJAnswerOfflineStatus";
static NSString *UserDefaults_YJAnswerOfflineAutoSubmitStatus = @"UserDefaults_YJAnswerOfflineAutoSubmitStatus";


/** 作业阶段类型 */
typedef NS_ENUM(NSInteger, YJTaskStageType) {
    YJTaskStageTypeAnswer = 0,              //作答
    YJTaskStageTypeHp,                      //互评
    YJTaskStageTypeHpViewer,                //互评查看
    YJTaskStageTypeViewer,                  //查看
    YJTaskStageTypeAnaLysisTopicViewer,     //试题分析试题查看
    YJTaskStageTypeCheck,                   //审核
    YJTaskStageTypeCheckViewer,             //审核查看
    YJTaskStageTypeManualMark,              //人工评阅
    YJTaskStageTypeManualMarkViewer,        //人工评阅查看
    YJTaskStageTypeAnalysis,                //分析
    YJTaskStageTypeAnalysisNoSubmit        //分析(未提交)
};

/** 大题作答类型 */
typedef NS_ENUM(NSInteger, YJBigTopicType) {
    YJBigTopicTypeDefault = 0,          //无大题题干与听力(不带分屏)
    YJBigTopicTypeChioceBlank,          //选词作答(选词填空，匹配题等)，作答时：不展示小题信息，点击题目作答区弹窗选择作答；非作答时：展示小题信息
    YJBigTopicTypeBigText,              //有大题题干(带分屏)
    YJBigTopicTypeBigTextAndBlank ,     //有大题题干且带填空(带分屏)
    YJBigTopicTypeBigTextAndListen,     //有大题题干与听力(带分屏)
    YJBigTopicTypeListen                //有听力(带分屏)
};

/** 口语试题 大题作答类型 */
typedef NS_ENUM(NSInteger, YJSpeechBigTopicType) {
    YJSpeechBigTopicTypeTalkChoice,     // 听对话选择
     YJSpeechBigTopicTypeShortChoice,   // 短文选择
     YJSpeechBigTopicTypeRead,          // 朗读
     YJSpeechBigTopicTypeFollowRead,    // 跟读
     YJSpeechBigTopicTypeScene,         // 情景问答
     YJSpeechBigTopicTypeTheme,         // 话题简述
     YJSpeechBigTopicTypeRepeat         // 复述
    
};

/** 小题作答类型 */
typedef NS_ENUM(NSInteger, YJSmallTopicType) {
    YJSmallTopicTypeChoice = 0,             //单项选择
    YJSmallTopicTypeMoreChoice,             //多项选择
    YJSmallTopicTypeBlank,                  //单项填空
    YJSmallTopicTypeSimpleAnswer,           //简答题
    YJSmallTopicTypeWritting               //作文题(主观题)
};

@class YJCorrectModel;
NS_ASSUME_NONNULL_BEGIN
@protocol YJPaperSmallProtocol <NSObject>
@optional
/** 翻译题断句List */
- (NSArray *)yj_smallQuesAskList;
/** 小题作答类型 */
- (YJSmallTopicType)yj_smallTopicType;
/** 小题作答模式ID */
- (NSInteger)yj_smallAnswerType;
/** 选择题选项信息(富文本) */
- (NSArray<NSMutableAttributedString *> *)yj_smallOptions;
/** 小题题干信息(富文本)-单个题干 */
- (NSMutableAttributedString *)yj_smallTopicAttrText;
/** 小题题干信息(富文本)-不含索引 */
- (NSMutableAttributedString *)yj_smallTopicContentAttrText;
/** 答题点数 */
- (NSInteger)yj_smallItemCount;
/** 小题分值 */
- (NSString *)yj_smallScore;
/** 多答题点的小题分值 */
- (NSString *)yj_smallMutiBlankScore;
/** 多答题点的小题总得分 */
- (NSString *)yj_smallMutiBlankAnswerScore;
/** 小题解析 */
- (NSString *)yj_smallAnswerAnalysis;
/** 小题参考答案 */
- (NSString *)yj_smallStandardAnswer;
- (NSMutableAttributedString *)yj_smallStandardAnswerAttrText;
/** 学生：小题作文各维度分数串,以"*"分割 */
- (NSString *)yj_smallWrittingScores;
/** 教师：小题作文各维度分数串,以"*"分割 */
- (NSString *)yj_smallWrittingScores_mark;
/** 小题得分 */
- (NSString *)yj_smallStuScore;
/** 智能评阅得分 */
- (NSString *)yj_smallIntelligenceScore;
/** 小题评语 */
- (void)yj_setSmallComment:(NSString *)comment;
- (NSString *)yj_smallComment;
/** 小题审核互评得分 */
- (NSString *)yj_smallCheckHpScore;
/** 小题索引 */
- (NSInteger)yj_smallIndex;
- (NSString *)yj_smallIndex_Ori;
- (NSInteger)yj_smallMutiBlankIndex;
/** 小题自增索引 */
- (NSInteger)yj_smallPaperIndex;
/** 小题是否需要互评 */
- (BOOL)yj_smallIsHpQues;
/** 作业阶段类型 */
- (YJTaskStageType)yj_taskStageType;
/** 审核：互评评分的学生名 */
- (NSString *)yj_taskHpStuName;

/** 英译中隐藏语音按钮 */
- (BOOL)yj_hideSpeechBtn;
- (BOOL)yj_translateTopic;
/** 大题题型名 */
- (NSString *)yj_bigTopicTypeName;
/** 文本资源地址 */
- (NSString *)yj_smallTopicArticle;
/** 是否离线 */
- (BOOL)yj_offline;
/** 任务ID */
- (NSString *)yj_assignmentID;
/** 离线文件夹路径 */
- (NSString *)yj_offlineFileDir;
@end

@protocol YJPaperBigProtocol <NSObject>

@optional
/** 大题作答类型 */
- (YJBigTopicType)yj_bigTopicType;
/** 大题题型名 */
- (NSString *)yj_bigTopicTypeName;
/** 大题题干信息 */
- (NSString *)yj_topicContent;
/** 听力原文信息 */
- (NSString *)yj_topicListenText;
/** 是否显示知识点信息 */
- (BOOL)yj_showTopicKlgInfo;
/** 重要知识点 */
- (NSString *)yj_topicImpKlgInfo;
/** 次重要知识点 */
- (NSString *)yj_topicMainKlgInfo;
/** 大题题干导语信息 */
- (NSString *)yj_topicDirectionTxt;
/** 大题题干信息(富文本) */
- (NSMutableAttributedString *)yj_bigTopicAttrText;
/** 大题题干信息不含导语(富文本) */
- (NSMutableAttributedString *)yj_bigTopicContentAttrText;
/** 音频地址 */
- (NSString *)yj_bigMediaUrl;
/** 文本资源地址 */
- (NSString *)yj_bigTopicArticle;
/** 音频地址数组 */
- (NSArray *)yj_bigMediaUrls;
- (NSString *)yj_bigAudioResStr;
/** 音频名数组 */
- (NSArray *)yj_bigMediaNames;
/** 选词作答(选词填空，匹配题等)作答答案List */
- (NSArray<NSString *> *)yj_bigChioceBlankTopicIndexList;
- (NSArray<NSString *> *)yj_bigChioceBlankAnswerList;
/** 大题ID */
- (NSString *)yj_bigTopicID;
/** 大题题型ID */
- (NSString *)yj_bigTopicTypeID;
/** 大题分值 */
- (NSString *)yj_bigScore;
/** 大题索引 */
- (NSInteger)yj_bigIndex;
/** 大题父类索引 */
- (NSInteger)yj_bigBaseIndex;

/** 重用池ID */
- (NSString *)yj_bigPoolID;
/** 小题List */
- (NSArray<id<YJPaperSmallProtocol>> *)yj_smallTopicList;
/** 成绩查阅 正确题数 */
- (NSInteger)yj_scoreLookRightQuesCount;
/** 成绩查阅 大题总得分 */
- (NSString *)yj_scoreLookBigTopicTotalScore;

/** 是否离线 */
- (BOOL)yj_offline;
/** 任务ID */
- (NSString *)yj_assignmentID;
/** 离线文件夹路径 */
- (NSString *)yj_offlineFileDir;

/** 口语试题题型 */
- (YJSpeechBigTopicType)yj_speechBigTopicType;
/** 口语导语音频地址 */
- (NSString *)yj_bigTopicPintroMidea;
- (NSString *)yj_bigTopicPintroMideaRelativePath;
- (NSString *)yj_bigTopicPintroMideaName;
- (NSString *)yj_bigTopicPintroMideaExtName;
/** 是否为标准改错题 */
- (BOOL)yj_isCorrectTopic;
/** 改错题导语 */
- (NSString *)yj_correntTopicPintro;
- (YJCorrectModel *)yj_correctModel;
/** 是否教师分析阶段 */
- (BOOL)yj_teachAnalysisStage;

@end

@protocol YJPaperProtocol <NSObject>

@optional
/** 大题List */
- (NSArray<id<YJPaperBigProtocol>> *)yj_bigTopicList;
/** 作业名称 */
- (NSString *)yj_taskName;
/** 作业总分 */
- (NSString *)yj_taskScore;

/** 答题卡资料Http路径 */
- (NSString *)yj_scantronHttp;
/** 答题卡资料音频Http路径 */
- (NSString *)yj_scantronAudio;
/** 是否为答题卡模式 */
- (BOOL)yj_isTopicCardMode;
/** 是否人工编辑资料 */
- (BOOL)yj_isManualWorkRes;
@end

NS_ASSUME_NONNULL_END
