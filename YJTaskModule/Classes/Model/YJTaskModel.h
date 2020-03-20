//
//  YJTaskModel.h
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "LGBaseModel.h"
#import "YJPaperModel.h"
#import "YJSpeechConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface YJTaskCourResModel : LGBaseModel
@property (nonatomic,copy) NSString *FileExtension;
@property (nonatomic,copy) NSString *FtpPath;
@property (nonatomic,copy) NSString *HttpPath;
@property (nonatomic,copy) NSString *MainResID;
@property (nonatomic,copy) NSString *fileName;
@end


@interface YJTaskModel : LGBaseModel
/** 作答ID */
@property (nonatomic,copy) NSString *AnswerID;
/** 非标准答案 */
@property (nonatomic,copy) NSString *AnswerStr;
/** 新增 作答内容富文本 */
@property (nonatomic,strong) NSMutableAttributedString *AnswerStr_Attr;
/** 资料提交时间 */
@property (nonatomic,copy) NSString *AnswerSubmitTime;
/** 任务单次作答时间 */
@property (nonatomic,assign) NSInteger AssignmentAnswerTimeAdd;
/** 资料单次作答时间 */
@property (nonatomic,assign) NSInteger TaskAnswerTimeAdd;
/** 任务ID */
@property (nonatomic,copy) NSString *AssignmentID;
/** 任务名 */
@property (nonatomic,copy) NSString *AssignmentName;
/** ftp路径 */
@property (nonatomic,copy) NSString *FtpScore;
/** 互评得分 */
@property (nonatomic,assign) float HpScore;
/** 谁互评了他的姓名 */
@property (nonatomic,copy) NSString *HpStuName;
/** 谁互评他的学号 */
@property (nonatomic,copy) NSString *HpXH;
/** http路径 */
@property (nonatomic,copy) NSString *HttpPath;
/** ftp路径 */
@property (nonatomic,copy) NSString *FtpPath;
/** 是否保存 */
@property (nonatomic,assign) BOOL IsSave;
/** 是否标准资料 */
@property (nonatomic,assign) BOOL IsStandard;
/** 是否提交 */
@property (nonatomic,assign) BOOL IsSubmited;
/** 文件扩展名 */
@property (nonatomic,copy) NSString *ResFileExtension;
/** 资料ID */
@property (nonatomic,copy) NSString *ResID;
/** 资料名 */
@property (nonatomic,copy) NSString *ResName;
/** 资料ID-数据库 */
@property (nonatomic,copy) NSString *ResourceID;
/** 资料类型ID,标准（20，26），答题卡(27),非标准(0) */
@property (nonatomic,assign) NSInteger ResOriginTypeID;

/** 学生名 */
@property (nonatomic,copy) NSString *StuName;
/** 学号 */
@property (nonatomic,copy) NSString *XH;
/** 学科ID */
@property (nonatomic,copy) NSString *SubjectID;
/** 学科名 */
@property (nonatomic,copy) NSString *SubjectName;
/** 学生得分 */
@property (nonatomic,assign) float StuScore;
/** 总分 */
@property (nonatomic,assign) float TotalScore;
/** Paper */
@property (nonatomic,strong) YJPaperModel *Paper;

/** 非标准多资料模型 */
@property (nonatomic,strong) NSArray<YJTaskCourResModel *> *CourResList;

/** 新增 */
@property (nonatomic,strong) YJSpeechConfig *bkSpeechConfig;
@property (nonatomic,strong) YJSpeechConfig *hwSpeechConfig;

/** 离线限时作答：是否已自动提交到本地 */
@property (nonatomic,assign) BOOL autoSubmitLocal;


- (BOOL)isVideoRes;
- (BOOL)isMusicRes;

- (NSString *)bkFtpRelativePath;




- (NSArray *)imgArrayByHtmlStr:(NSString *)htmlStr;
- (void)submitUpdateAnswerStr:(NSString *)AnswerStr;
- (void)configAnswerStr:(NSString *)htmlStr;
- (void)initImgInfoWithHtmlAttr:(NSAttributedString *)htmlAttr;
- (void)setHtmlValueDic:(NSDictionary *)valueDic htmlAttr:(NSAttributedString *)htmlAttr;

- (NSString *)yj_htmlBodyContentWithHtmlAttributedText:(NSAttributedString *) attributedText;
@end

NS_ASSUME_NONNULL_END
