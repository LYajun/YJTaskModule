//
//  YJPaperModel.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJBasePaperModel.h"
#import "YJSpeechClauseModel.h"
#import "YJSpeechSaveModel.h"
#import "YJCorrectModel.h"
#import <YJTaskMark/YJSpeechResultModel.h>

@interface YJPaperTextAttachment: NSTextAttachment

@end

NS_ASSUME_NONNULL_BEGIN
@interface YJPaperSmallModel : YJBasePaperSmallModel
@property (nonatomic,strong) NSArray *AnswerImgUrlList;
/** 作答得分 */
@property (nonatomic,assign) float AnswerScore;
/** 小题作答答案（多个答题点的答案用char1分割） */
@property (nonatomic,copy) NSString *AnswerStr;
/** 作答模式 */
@property (nonatomic,assign) NSInteger AnswerType;

@property (nonatomic,copy) NSString *Comment;
@property (nonatomic,copy) NSString *IntelligenceScore;
/** 互评得分 */
@property (nonatomic,assign) float HpScore;
/** 小题索引 */
@property (nonatomic,assign) NSInteger Index;
@property (nonatomic,copy) NSString *IndexOri;
/** 该题是否需要互评 */
@property (nonatomic,assign) BOOL IsHpQues;
/** 该题是否需要互评 */
@property (nonatomic,assign) BOOL IsHpTimu;
/** 选择题选项 */
@property (nonatomic,strong) NSArray *OptionKeyList;
/** 选择题选项内容 */
@property (nonatomic,strong) NSArray *OptionContentList;
@property (nonatomic,strong) NSMutableArray *OptionContentList_attr;
/** 整份试卷第几题 */
@property (nonatomic,assign) NSInteger PaperIndex;
@property (nonatomic,assign) NSInteger PaperIndexOri;
/** 题目解析 */
@property (nonatomic,copy) NSString *QuesAnalysis;
/** 参考答案 */
@property (nonatomic,copy) NSString *QuesAnswer;
@property (nonatomic,copy) NSMutableAttributedString *QuesAnswer_attr;
/** 题目 */
@property (nonatomic,copy) NSString *QuesAsk;
@property (nonatomic,copy) NSMutableAttributedString *QuesAsk_attr;
/** 小题音频 */
@property (nonatomic,copy) NSString *QuesAudio;
/** 小题满分 */
@property (nonatomic,assign) float QuesScore;
/** 词汇分数 - 学生 */
@property (nonatomic,copy) NSString *WordRichScoreStr;
/** 主题分数 - 学生 */
@property (nonatomic,copy) NSString *ThemeScoreStr;
/** 语法分数 - 学生 */
@property (nonatomic,copy) NSString *YuFaCentciScoreStr;
/** 句型分数 - 学生 */
@property (nonatomic,copy) NSString *SentenceScoreStr;

/** 词汇分数 - 教师 */
@property (nonatomic,copy) NSString *WordRichMarkScoreStr;
/** 主题分数 - 教师 */
@property (nonatomic,copy) NSString *ThemeMarkScoreStr;
/** 语法分数 - 教师 */
@property (nonatomic,copy) NSString *YuFaCentciMarkScoreStr;
/** 句型分数 - 教师 */
@property (nonatomic,copy) NSString *SentenceMarkScoreStr;

/** 学生得分 */
@property (nonatomic,assign) float StuScore;
/** 大题ID */
@property (nonatomic,copy) NSString *TopicID;
/** 历次得分 */
@property (nonatomic,strong) NSArray<YJSpeechSaveScoreModel *> *ScoreInfoList;
/** 翻译题的断句List */
@property (nonatomic,strong) NSArray *QuesAskList;
/** 新增 - 大题题型ID */
@property (nonatomic,copy) NSString *TopicTypeID;
/** 新增 - 小题作答点数 */
@property (nonatomic,assign) NSInteger itemCount;
/** 新增 - 大题题型名 */
@property (nonatomic,copy) NSString *TopicTypeName;

/** 新增 - 分句朗读 */
@property (nonatomic,strong) NSArray<YJSpeechClauseModel *> *ClauseList;
/**  新增 - 评测结果 */
@property (nonatomic,strong) YJSpeechResultModel *speechResultModel;
/** 新增 - 是否显示多答题点 */
@property (nonatomic,assign) BOOL mutiBlankDisplayEnable;
/** 新增 - 多答题点试题总分 */
@property (nonatomic,assign) float mutiBlankQuesScore;
/** 新增 - 多答题点试题总得分 */
@property (nonatomic,assign) float mutiBlankQuesStuScore;
/** 新增 - 多答题点实际索引 */
@property (nonatomic,assign) NSInteger mutiBlankIndex;
@end

@interface YJPaperBigModel : YJBasePaperBigModel
/** 大题已作答时间 */
@property (nonatomic,assign) NSInteger AnswerTime;
/** 大题单次作答时间 */
@property (nonatomic,assign) NSInteger AnswerTimeAdd;
/** 音频地址 */
@property (nonatomic,copy) NSString *AudioResStr;
/** 难度 */
@property (nonatomic,copy) NSString *Difficulty;
/** 重要知识点ID */
@property (nonatomic,copy) NSString *ImportantKlg;
/** 次要知识点ID */
@property (nonatomic,copy) NSString *MainKlg;
/** 大题索引 */
@property (nonatomic,assign) NSInteger Index;
/** 是否需要分屏处理 */
@property (nonatomic,assign) BOOL IsQuesInContent;
/** 图片名字字符串，以","分隔 */
@property (nonatomic,copy) NSString *PicResStr;
/** 小题数量 */
@property (nonatomic,assign) NSInteger QuesCount;
/** 文本资源地址:如听力原文 */
@property (nonatomic,copy) NSString *TopicArticle;
@property (nonatomic,copy) NSMutableAttributedString *TopicArticle_attr;
/** 大题题目内容 */
@property (nonatomic,copy) NSString *TopicContent;
@property (nonatomic,copy) NSMutableAttributedString *TopicContent_attr;
/** 大题ID */
@property (nonatomic,copy) NSString *TopicID;
/** 教学中心大题索引 */
@property (nonatomic,assign) NSInteger TopicIndexEdu;
/** 导语 */
@property (nonatomic,copy) NSString *TopicPintro;
@property (nonatomic,copy) NSString *TopicPintro_copy;
/** 导语 音频路径 */
@property (nonatomic,copy) NSString *TopicPintroMidea;

/** 大题满分 */
@property (nonatomic,assign) float TopicScore;
/** 主题 */
@property (nonatomic,copy) NSString *TopicTheme;
/** 大题类型ID */
@property (nonatomic,copy) NSString *TopicTypeID;
/** 大题类型名 */
@property (nonatomic,copy) NSString *TopicTypeName;
@property (nonatomic,copy) NSString *TopicTypeOtherName;
@property (nonatomic,copy) NSString *TopicGenreName;
/** 改错题信息 */
@property (nonatomic,strong) YJCorrectModel *GCQues;
/** 小题List */
@property (nonatomic,strong) NSArray<YJPaperSmallModel *> *Queses;
@property (nonatomic,strong) NSArray *QuesOri;
/** 重要知识点 */
@property (nonatomic,copy) NSString *ImporKnText;
/** 次要知识点 */
@property (nonatomic,copy) NSString *MainKnText;
@property (nonatomic,copy) NSString *ThemeKeywordCode;
@property (nonatomic,copy) NSString *ThemeKeywordText;
@property (nonatomic,copy) NSString *UpperKnlgCode;
@property (nonatomic,copy) NSString *UpperKnlgText;
/** 主题知识点 */
@property (nonatomic,copy) NSString *ThemeCode;
@property (nonatomic,copy) NSString *ThemeText;
/** 来源 */
@property (nonatomic,copy) NSString *LibCode;
@property (nonatomic,copy) NSString *ResType;
/** 听说作业ftp信息 */
@property (nonatomic,copy) NSString *ftpPre;

/** 新增 - 是否显示知识点信息 */
@property (nonatomic,assign) BOOL klgInfoDisplayEnable;
/** 新增-是否教师分析阶段 */
@property (nonatomic,assign) BOOL taskStageTypeTeachAnalysis;

@end

@interface YJPaperModel : YJBasePaperModel
/** 已作答题目数 */
@property (nonatomic,assign) NSInteger AnswerQuesNum;
/** 已互评题目数 */
@property (nonatomic,assign) NSInteger HpQuesNum;
/** 互评总题目数 */
@property (nonatomic,assign) NSInteger HpQuesTotalNum;
/** 重要知识点 */
@property (nonatomic,copy) NSString *ImportantKlg;
/** 是否主观作业 */
@property (nonatomic,assign) BOOL IsSubjective;
/** 主要知识点 */
@property (nonatomic,copy) NSString *MainKlg;
/** 试卷ID */
@property (nonatomic,copy) NSString *PapaerID;
/** 批改题目数量 */
@property (nonatomic,assign) NSInteger PgQuesNum;
/** 小题总数 */
@property (nonatomic,assign) NSInteger QuesCount;
/** 互评题目总数 */
@property (nonatomic,assign) NSInteger QuesHpCount;
/** 资料类型ID,标准（20，26），答题卡(27),非标准(0),人工试卷编辑工具-标准(34)，口语（28） */
@property (nonatomic,assign) NSInteger ResOriginTypeID;
/** 答题卡资料Http路径 */
@property (nonatomic,copy) NSString *ScantronHttp;
/** 答题卡资料Ftp路径 */
@property (nonatomic,copy) NSString *ScantronFtp;
/** 答题卡资料音频Http路径 */
@property (nonatomic,copy) NSString *ScantronAudio;
/** 学生名 */
@property (nonatomic,copy) NSString *StuName;
/** 学科ID */
@property (nonatomic,copy) NSString *SubjectID;
/** 学科名 */
@property (nonatomic,copy) NSString *SubjectName;
/** 作业总分 */
@property (nonatomic,assign) float TaskTotalScore;
/** 大题数 */
@property (nonatomic,assign) NSInteger TopicCount;
/** 学号 */
@property (nonatomic,copy) NSString *XH;


/** 谁互评了他的姓名 */
@property (nonatomic,copy) NSString *HpStuName;

/** 是否提交 */
@property (nonatomic,assign) BOOL isSubmit;
/** 大题List */
@property (nonatomic,strong) NSArray<YJPaperBigModel *> *Topics;
/** 上次保存的大题索引 */
@property (nonatomic,assign) NSInteger LastAnsTopic;
/** 上次保存的小题索引 */
@property (nonatomic,assign) NSInteger LastAnsQues;
/** 新增 教案ID 随堂测试上传数据用*/
@property (nonatomic,copy) NSString *LessonPlanID;
@end

NS_ASSUME_NONNULL_END
