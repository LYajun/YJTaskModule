//
//  YJPaperModel.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJPaperModel.h"
#import "YJConst.h"
#import <YJExtensions/YJEHpple.h>

static NSString *kHpStuName = @"";



NSString *YJTaskModuleHandleImgLabInfo(NSString *htmlStr){
    NSString *TopicContent = htmlStr;
    if ([TopicContent.lowercaseString containsString:@"<img"]) {
        NSRegularExpression *imgRegularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*?>" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray<NSTextCheckingResult *> *arr = [imgRegularExpretion matchesInString:TopicContent options:NSMatchingReportCompletion range:NSMakeRange(0, TopicContent.length)];
        if (!IsArrEmpty(arr)) {
            for (NSTextCheckingResult *result in arr) {
                NSRange matchRange = result.range;
                NSString *str = [TopicContent substringWithRange:matchRange];
                NSData *htmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
                YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
                NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
               if (!IsArrEmpty(imgArray)) {
                   YJEHppleElement *hppleElement = imgArray.firstObject;
                   NSDictionary *attributes = hppleElement.attributes;
                   NSString *imgSrc = [attributes objectForKey:@"src"];
                   TopicContent = [TopicContent stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>",imgSrc,str]];
               }
            }
        }
    }
    return TopicContent;
}


@implementation YJPaperTextAttachment
@end
@interface YJPaperBlankTextField : UITextField

@end
@implementation YJPaperBlankTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType =  UITextAutocapitalizationTypeNone;
        self.borderStyle = UITextBorderStyleNone;
        self.clearButtonMode = UITextFieldViewModeNever;
        
        CALayer *line = [[CALayer alloc] init];
        line.backgroundColor = LG_ColorWithHex(0x252525).CGColor;
        line.frame = CGRectMake(0, frame.size.height -1, frame.size.width, 1);
        [self.layer addSublayer:line];
    }
    return self;
}
@end

@implementation YJPaperSmallModel
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"hash",@"superclass",@"description",@"debugDescription",@"QuesAsk_attr",@"OptionContentList_attr",@"QuesAnswer_attr",@"yj_smallAnswerScore",@"yj_smallAnswerArr",@"yj_smallAnswer",@"yj_smallItemCount",@"ClauseList",@"speechResultModel"];
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"ClauseList":[YJSpeechClauseModel class],
             @"ScoreInfoList":[YJSpeechSaveScoreModel class]
             };
}
- (NSString *)yj_filterPBrHtml:(NSString *)html{
    if (!html || html.length == 0) {
        return @"";
    }
    html = html.yj_deleteWhitespaceCharacter;
    if ([html.lowercaseString hasPrefix:@"<p"] && [html.lowercaseString hasSuffix:@"p></p>"]) {
        NSMutableString *hString = html.mutableCopy;
        [hString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"<b"];
        NSRange range = [hString.lowercaseString rangeOfString:@"<p"];
        [hString deleteCharactersInRange:NSMakeRange(0, range.location)];
        [hString deleteCharactersInRange:NSMakeRange(hString.length-4, 4)];
        html = hString;
    }
    if ([html hasSuffix:@"<br>"] || [html hasSuffix:@"<BR>"]) {
        html = [html substringToIndex:html.length-4];
    }
    if ([html hasSuffix:@"</br>"] || [html hasSuffix:@"</BR>"]) {
        html = [html substringToIndex:html.length-5];
    }
    if ([html.lowercaseString containsString:@"</p>"] && [html.lowercaseString componentsSeparatedByString:@"</p>"].count == 2) {
        html = [html stringByReplacingOccurrencesOfString:@"<p" withString:@"<strong"];
        html = [html stringByReplacingOccurrencesOfString:@"<P" withString:@"<strong"];
        html = [html stringByReplacingOccurrencesOfString:@"p>" withString:@"strong>"];
        html = [html stringByReplacingOccurrencesOfString:@"P>" withString:@"strong>"];
    }
    return html;
}
- (YJTaskStageType)yj_taskStageType{
    YJTaskStageType type = [NSUserDefaults yj_integerForKey:UserDefaults_YJTaskStageType];
    return type;
}
- (void)setOptionContentList:(NSArray *)OptionContentList{
    _OptionContentList = OptionContentList;
    _OptionContentList_attr = [NSMutableArray array];
    if (!IsArrEmpty(OptionContentList)) {
        for (NSString *str in OptionContentList) {
            NSString *s = [self yj_filterPBrHtml:str];
//            if (self.yj_offline && [str.lowercaseString containsString:@"<img"]) {
//                [_OptionContentList_attr addObject:[s yj_configOfflineImgAtFilePath:self.yj_offlineFileDir]];
//            }else{
                [_OptionContentList_attr addObject:s.yj_toHtmlMutableAttributedString];
//            }
        }
    }
}
- (void)updateOptionContentList:(NSArray *)OptionContentList optionContentList_attr:(NSMutableArray *)optionContentList_attr{
    _OptionContentList = OptionContentList;
    _OptionContentList_attr = optionContentList_attr;
}
- (void)setQuesAsk:(NSString *)QuesAsk{
    if (!IsStrEmpty(QuesAsk)) {
        NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"(?isx)<(span|p)[^>]*>[^<>]*((?<!\\d)(?=(\\d{1,3}(\\.|．|、)))[^<>]*)</(span|p)>" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRange firstRange = [regularExpretion rangeOfFirstMatchInString:QuesAsk options:NSMatchingReportProgress range:NSMakeRange(0, QuesAsk.length)];
        if (firstRange.location != NSNotFound) {
            QuesAsk = [QuesAsk stringByReplacingCharactersInRange:firstRange withString:@""];
        }
        QuesAsk = YJTaskModuleHandleImgLabInfo(QuesAsk);
    }
    
    QuesAsk = [self yj_filterPBrHtml:QuesAsk];
    if (!IsStrEmpty(QuesAsk) &&
        [QuesAsk containsString:@"___"] &&
        [QuesAsk componentsSeparatedByString:@"___"].count > 2) {
        NSArray *arr = [QuesAsk componentsSeparatedByString:@" "];
        int count = 0;
        for (NSString *word in arr) {
            if ([word containsString:@"___"]) {
                if ([word containsString:@"____"]) {
                    NSRange range = [QuesAsk rangeOfString:@"____"];
                    if (range.location != NSNotFound) {
                        QuesAsk = [QuesAsk stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c%c",20,count+1]];
                    }
                }else{
                    NSRange range = [QuesAsk rangeOfString:@"___"];
                    if (range.location != NSNotFound) {
                        QuesAsk = [QuesAsk stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",count+1]];
                    }
                }
                count++;
            }
        }
        self.itemCount = count;
    }
    _QuesAsk = QuesAsk;
    _QuesAsk_attr = QuesAsk.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
}
- (NSInteger)yj_smallItemCount{
    if (self.mutiBlankDisplayEnable && !IsStrEmpty(self.IndexOri) && self.AnswerType == 2) {
        return self.itemCount;
    }
    return 0;
}
- (void)setAnswerImgUrlList:(NSArray *)AnswerImgUrlList{
    _AnswerImgUrlList = AnswerImgUrlList;
    self.yj_imgUrlArr = AnswerImgUrlList;
}
- (void)setYj_imgUrlArr:(NSArray *)yj_imgUrlArr{
    [super setYj_imgUrlArr:yj_imgUrlArr];
    _AnswerImgUrlList = yj_imgUrlArr;
}
- (void)setAnswerStr:(NSString *)AnswerStr{
    if (!IsStrEmpty(AnswerStr) && IsStrEmpty([AnswerStr stringByReplacingOccurrencesOfString:YJTaskModule_u2060 withString:@""].yj_deleteWhitespaceAndNewlineCharacter)) {
        AnswerStr = @"";
    }
    _AnswerStr = AnswerStr;
    self.yj_smallAnswer = AnswerStr;
}

- (NSString *)yj_smallStandardAnswer{
    if (IsStrEmpty(self.QuesAnswer)) {
        return @"略";
    }
    if ([self.QuesAnswer containsString:@"&nbsp;"]) {
       self.QuesAnswer = [self.QuesAnswer stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }
    if (!IsStrEmpty(self.QuesAnswer) && [self.QuesAnswer containsString:YJTaskModule_u2063]) {
        self.QuesAnswer = [self.QuesAnswer stringByReplacingOccurrencesOfString:YJTaskModule_u2063 withString:@"\n"];
    }
    return [NSString yj_filterHTML:self.QuesAnswer];
}
- (void)setQuesAnswer:(NSString *)QuesAnswer{
    if ([QuesAnswer containsString:@"&nbsp"]) {
        _QuesAnswer = QuesAnswer.yj_toHtmlMutableAttributedString.string;
    }else{
        _QuesAnswer = QuesAnswer;
    }
//    _QuesAnswer_attr = QuesAnswer.yj_htmlToMutableAttributedString;
}
//- (NSMutableAttributedString *)yj_smallStandardAnswerAttrText{
//    if (IsStrEmpty(self.QuesAnswer)) {
//        return [[NSMutableAttributedString alloc] initWithString:@"-"];
//    }else{
//        return self.QuesAnswer_attr;
//    }
//}
- (NSInteger)yj_smallIndex{
    return self.Index;
}
- (NSInteger)yj_smallMutiBlankIndex{
    return self.mutiBlankIndex;
}
- (NSString *)yj_smallIndex_Ori{
    if (self.mutiBlankDisplayEnable) {
        return self.IndexOri;
    }
    return @"";
}
- (NSInteger)yj_smallPaperIndex{
    if (self.mutiBlankDisplayEnable && self.PaperIndexOri > 0) {
        return self.PaperIndexOri;
    }
    return self.PaperIndex;
}
- (NSString *)yj_smallAnswerAnalysis{
    if (!IsStrEmpty(self.QuesAnalysis) && [self.QuesAnalysis containsString:@"&nbsp;"]) {
        self.QuesAnalysis = [self.QuesAnalysis stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    }
    return [NSString yj_filterHTML:self.QuesAnalysis];
}
- (NSString *)yj_smallTopicArticle{
    return self.QuesAudio;
}
- (NSMutableAttributedString *)yj_smallTopicAttrText{
    NSString *index = [NSString stringWithFormat:@"(%li)、",self.yj_smallPaperIndex];
    NSString *score;
    if (self.yj_smallItemCount > 1) {
        score = [NSString stringWithFormat:@"[%.1f分]",self.mutiBlankQuesScore];
    }else{
        score = [NSString stringWithFormat:@"[%.1f分]",self.QuesScore];
    }
    if (self.QuesAsk_attr) {
        if (![self.QuesAsk_attr.string hasPrefix:index]) {
            [self.QuesAsk_attr insertAttributedString:[[NSAttributedString alloc] initWithString:index] atIndex:0];
            [self.QuesAsk_attr appendAttributedString:[[NSAttributedString alloc] initWithString:score]];
        }
        if (self.yj_smallItemCount > 1) {
            NSMutableAttributedString *attr = self.QuesAsk_attr.mutableCopy;
            for (int i = 0; i < self.itemCount; i++) {
                YJPaperBlankTextField *btn = [[YJPaperBlankTextField alloc] initWithFrame:CGRectMake(0, 0, 30, 22)];
                btn.font = [UIFont systemFontOfSize:14];
                btn.textColor = LG_ColorWithHex(0x252525);
                btn.text = [NSString yj_stringToSmallTopicIndexStringWithIntCount:i];
                YJPaperTextAttachment *textAttachment = [[YJPaperTextAttachment alloc] initWithData:nil ofType:nil] ;
                textAttachment.image = [UIImage yj_imageWithView:btn];
                NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
                NSMutableAttributedString *imageString = [[NSMutableAttributedString alloc] initWithAttributedString:textAttachmentString];
                NSRange range = [attr.string rangeOfString:[NSString stringWithFormat:@"%c%c",20,i+1]];
                if (range.location == NSNotFound) {
                    range = [attr.string rangeOfString:[NSString stringWithFormat:@"%c",i+1]];
                }
                if (range.location != NSNotFound) {
                    [attr replaceCharactersInRange:range withAttributedString:imageString];
                }
            }
            return attr;
        }else{
            NSMutableAttributedString *attr = self.QuesAsk_attr.mutableCopy;
            for (int i = 0; i < self.itemCount; i++) {
                NSRange range = [attr.string rangeOfString:[NSString stringWithFormat:@"%c%c",20,i+1]];
                if (range.location != NSNotFound) {
                    [attr replaceCharactersInRange:range withAttributedString:@"____".yj_toMutableAttributedString];
                }else{
                    range = [attr.string rangeOfString:[NSString stringWithFormat:@"%c",i+1]];
                    if (range.location != NSNotFound) {
                        [attr replaceCharactersInRange:range withAttributedString:@"___".yj_toMutableAttributedString];
                    }
                }
            }
            return attr;
        }
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:index];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:score]];
        return attr;
    }
}
- (NSMutableAttributedString *)yj_smallTopicContentAttrText{
    return self.QuesAsk_attr;
}
- (NSArray<NSMutableAttributedString *> *)yj_smallOptions{
    return self.OptionContentList_attr;
}
- (NSString *)yj_smallScore{
    return [NSString stringWithFormat:@"%.1f",self.QuesScore];
}
- (NSString *)yj_smallMutiBlankScore{
    return [NSString stringWithFormat:@"%.1f",self.mutiBlankQuesScore];
}
- (void)yj_setSmallComment:(NSString *)comment{
    _PyResult = comment;
    _Comment = comment;
}
- (NSString *)yj_smallComment{
    if (!IsStrEmpty(self.PyResult)) {
        return self.PyResult;
    }
    return self.Comment;
}
- (NSString *)yj_smallIntelligenceScore{
    NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    if (UserType == 1) {
        return self.IntelligenceScore;
    }
    return @"";
}
- (NSArray *)yj_smallQuesAskList{
    YJTaskStageType taskStateType = [NSUserDefaults yj_integerForKey:UserDefaults_YJTaskStageType];
    if (!IsArrEmpty(self.QuesAskList) && self.QuesAskList.count > 1  && [self.TopicTypeID isEqualToString:@"g"] && (taskStateType == YJTaskStageTypeAnswer || taskStateType == YJTaskStageTypeViewer)) {
        return self.QuesAskList;
    }
    return nil;
}
- (void)updateSmallAnswerStr:(NSString *)answer atIndex:(NSInteger)index{
    NSMutableArray *answerArr = [NSMutableArray array];
    NSArray *answerStrList = nil;
    if (!IsStrEmpty(self.yj_smallAnswer)) {
        answerStrList = [self.yj_smallAnswer componentsSeparatedByString:YJTaskModule_u2060];
    }
    for (int i = 0; i < self.yj_smallQuesAskList.count; i++) {
        if (i == index) {
            [answerArr addObject:kApiParams(answer)];
        }else{
            if (!IsArrEmpty(answerStrList) && i <= answerStrList.count-1) {
                [answerArr addObject:answerStrList[i]];
            }else{
                [answerArr addObject:@""];
            }
        }
    }
    self.yj_smallAnswer = [answerArr componentsJoinedByString:YJTaskModule_u2060];
}
- (YJSmallTopicType)yj_smallTopicType{
    YJSmallTopicType smallType = 0;
    switch (self.AnswerType) {
        case 1:
            smallType = YJSmallTopicTypeChoice;
            break;
        case 2:
            smallType = YJSmallTopicTypeBlank;
            break;
        case 4:
        {
            if ([self.TopicTypeID isEqualToString:@"f"]) {
                smallType = YJSmallTopicTypeWritting;
            }else{
                smallType = YJSmallTopicTypeSimpleAnswer;
            }
        }
            break;
        case 16:
            smallType = YJSmallTopicTypeMoreChoice;
            break;
        default:
            break;
    }
    return smallType;
}
-  (BOOL)yj_hideSpeechBtn{
    if ([self.TopicTypeID isEqualToString:@"g"] && !IsStrEmpty(self.TopicTypeName) && [self.TopicTypeName containsString:@"英译中"]) {
        return YES;
    }
    return NO;
}
- (BOOL)yj_translateTopic{
    if ([self.TopicTypeID isEqualToString:@"g"]){
        return YES;
    }
    return NO;
}
- (NSString *)yj_bigTopicTypeName{
    return self.TopicTypeName;
}
- (NSInteger)yj_smallAnswerType{
    return self.AnswerType;
}


- (void)setYj_smallAnswer:(NSString *)yj_smallAnswer{
    if (!IsStrEmpty(yj_smallAnswer) && IsStrEmpty([yj_smallAnswer stringByReplacingOccurrencesOfString:YJTaskModule_u2060 withString:@""].yj_deleteWhitespaceAndNewlineCharacter)) {
        yj_smallAnswer = @"";
    }
    [super setYj_smallAnswer:yj_smallAnswer];
    if ([yj_smallAnswer containsString:[NSString yj_Char1]]) {
        yj_smallAnswer = [yj_smallAnswer stringByReplacingOccurrencesOfString:[NSString yj_Char1] withString:[NSString yj_StandardAnswerSeparatedStr]];
    }
    _AnswerStr = yj_smallAnswer;
}
- (NSString *)yj_smallWrittingScores{
    if (self.yj_smallTopicType == YJSmallTopicTypeWritting) {
        return [NSString stringWithFormat:@"%@*%@*%@*%@",self.WordRichScoreStr,self.ThemeScoreStr,self.YuFaCentciScoreStr,self.SentenceScoreStr];
    }else{
        return [NSString stringWithFormat:@"%.1f",self.HpScore];
    }
}
- (NSString *)yj_smallCheckHpScore{
    return [NSString stringWithFormat:@"%.1f",self.HpScore];
}
- (NSString *)yj_smallWrittingScores_mark{
    if (self.yj_smallTopicType == YJSmallTopicTypeWritting) {
        return [NSString stringWithFormat:@"%@*%@*%@*%@",self.WordRichMarkScoreStr,self.ThemeMarkScoreStr,self.YuFaCentciMarkScoreStr,self.SentenceMarkScoreStr];
    }else{
        return [NSString stringWithFormat:@"%.1f",self.AnswerScore];
    }
}
- (NSString *)yj_taskHpStuName{
    return kHpStuName;
}
- (NSString *)yj_smallStuScore{
    if ([self yj_taskStageType] == YJTaskStageTypeCheck || [self yj_taskStageType] == YJTaskStageTypeCheckViewer ||[self yj_taskStageType] == YJTaskStageTypeManualMark || [self yj_taskStageType] == YJTaskStageTypeManualMarkViewer) {
        return [NSString stringWithFormat:@"%.1f",self.AnswerScore];
    }else{
        return [NSString stringWithFormat:@"%.1f",self.HpScore];
    }
}
- (NSString *)yj_smallAnswerScore{
    return [NSString stringWithFormat:@"%.1f",self.StuScore];
}
- (NSString *)yj_smallMutiBlankAnswerScore{
    return [NSString stringWithFormat:@"%.1f",self.mutiBlankQuesStuScore];
}
- (void)setYj_smallAnswerScore:(NSString *)yj_smallAnswerScore{
    [super setYj_smallAnswerScore:yj_smallAnswerScore];
    if ([self yj_taskStageType] == YJTaskStageTypeManualMark || [self yj_taskStageType] == YJTaskStageTypeManualMarkViewer) {
        _AnswerScore = yj_smallAnswerScore.floatValue;
    }else{
        if ([self yj_taskStageType] == YJTaskStageTypeCheck || [self yj_taskStageType] == YJTaskStageTypeCheckViewer) {
            if (self.yj_smallTopicType == YJSmallTopicTypeWritting) {
                NSArray *scores = [yj_smallAnswerScore componentsSeparatedByString:@"*"];
                _WordRichMarkScoreStr = scores[0];
                _ThemeMarkScoreStr = scores[1];
                _YuFaCentciMarkScoreStr = scores[2];
                _SentenceMarkScoreStr = scores[3];
                NSInteger WordRichStarCount = [[_WordRichMarkScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger ThemeStarCount = [[_ThemeMarkScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger YuFaStarCount = [[_YuFaCentciMarkScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger SentenceStarCount = [[_SentenceMarkScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                CGFloat score = (WordRichStarCount+ThemeStarCount+YuFaStarCount+SentenceStarCount)*self.QuesScore/20;
                _AnswerScore = score;
            }else{
                _AnswerScore = yj_smallAnswerScore.floatValue;
            }
        }else{
            if (self.yj_smallTopicType == YJSmallTopicTypeWritting) {
                NSArray *scores = [yj_smallAnswerScore componentsSeparatedByString:@"*"];
                _WordRichScoreStr = scores[0];
                _ThemeScoreStr = scores[1];
                _YuFaCentciScoreStr = scores[2];
                _SentenceScoreStr = scores[3];
                NSInteger WordRichStarCount = [[_WordRichScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger ThemeStarCount = [[_ThemeScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger YuFaStarCount = [[_YuFaCentciScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                NSInteger SentenceStarCount = [[_SentenceScoreStr componentsSeparatedByString:@"/"].firstObject integerValue];
                CGFloat score = (WordRichStarCount+ThemeStarCount+YuFaStarCount+SentenceStarCount)*self.QuesScore/20;
                _HpScore = score;
            }else{
                _HpScore = yj_smallAnswerScore.floatValue;
            }
        }
    }
}
- (BOOL)yj_smallIsHpQues{
    return self.IsHpQues;
}
- (BOOL)yj_offline{
    BOOL isOffline = [NSUserDefaults yj_boolForKey:UserDefaults_YJAnswerOfflineStatus];
    return isOffline;
}
- (NSString *)yj_assignmentID{
    NSString *assignmentID = [NSUserDefaults yj_stringForKey:UserDefaults_YJTaskOfflineAssignmentID];
    if (IsStrEmpty(assignmentID)) {
        return @"";
    }
    return assignmentID;
}


@end
@implementation YJPaperBigModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Queses":[YJPaperSmallModel class]};
}
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"hash",@"superclass",@"description",@"debugDescription",@"TopicContent_attr",@"TopicArticle_attr"];
}
- (void)setTopicPintroMidea:(NSString *)TopicPintroMidea{
    if (!IsStrEmpty(TopicPintroMidea) && [TopicPintroMidea containsString:@"\\"]) {
        TopicPintroMidea = [TopicPintroMidea stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    }
    _TopicPintroMidea = TopicPintroMidea;
}
- (NSString *)yj_bigTopicPintroMidea{
    return self.TopicPintroMidea;
}
 // @"http://139.9.77.198:10118/lgftp/LBD_TeachProgram/zengruiyan1/8420ad15-99bd-4569-a737-ec8b24b7134c/AfterClassProgram/P20190330114447506/听对话回答问题/听对话回答问题导语.mp3"
- (NSString *)yj_bigTopicPintroMideaRelativePath{
    NSString *allName = [self.TopicPintroMidea componentsSeparatedByString:@"/"].lastObject;
    NSString *path = [self.TopicPintroMidea componentsSeparatedByString:@":"].lastObject;
    NSString *port = [self.TopicPintroMidea componentsSeparatedByString:@"/"].firstObject;
    NSString *path1 = [path substringFromIndex:port.length];
    
    NSString *relativePath = [path1 stringByReplacingOccurrencesOfString:allName withString:@""];
    
    return relativePath;
}
- (NSString *)yj_bigTopicPintroMideaName{
    NSString *allName = [self.TopicPintroMidea componentsSeparatedByString:@"/"].lastObject;
//    NSString *name = [allName componentsSeparatedByString:@"."].firstObject;
    return allName;
}

- (NSString *)yj_bigTopicPintroMideaExtName{
    NSString *allName = [self.TopicPintroMidea componentsSeparatedByString:@"/"].lastObject;
    NSString *name = [allName componentsSeparatedByString:@"."].lastObject;
    return name;
}
- (void)setQueses:(NSArray<YJPaperSmallModel *> *)Queses{
    _Queses = Queses;
    for (YJPaperSmallModel *smallModel in Queses) {
        smallModel.TopicTypeID = self.TopicTypeID;
        smallModel.TopicTypeName = self.yj_bigTopicTypeName;
    }
}
- (void)setTopicContent:(NSString *)TopicContent{
    if (!IsStrEmpty(TopicContent)) {
        NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"(?isx)[_]*(<u>)*(\\d{1,3}(\\.|．|、)*)(</u>)*[_]+" options:NSRegularExpressionCaseInsensitive error:nil];
        TopicContent = [regularExpretion stringByReplacingMatchesInString:TopicContent options:NSMatchingReportProgress range:NSMakeRange(0, TopicContent.length) withTemplate:@"____"];
        TopicContent = YJTaskModuleHandleImgLabInfo(TopicContent);
    }
    _TopicContent = TopicContent;
    _TopicContent_attr = TopicContent.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
}
- (void)setTopicPintro:(NSString *)TopicPintro{
    _TopicPintro = TopicPintro;
    _TopicPintro_copy = TopicPintro;
    if (!IsStrEmpty(TopicPintro)) {
        if ([TopicPintro containsString:@"&nbsp;"]) {
            TopicPintro = [TopicPintro stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        }
        _TopicPintro = [NSString yj_filterHTML:TopicPintro];
    }
}
- (NSString *)yj_topicDirectionTxt{
    return self.TopicPintro;
}
- (NSString *)yj_correntTopicPintro{
    return self.GCQues.QuesLeaderContent;
}

- (NSString *)topicContentInfo{
    NSString *topicContent = @"";
    if ([self yj_isCorrectTopic] && !IsStrEmpty(self.GCQues.QuesLeaderContent)) {
        _TopicPintro = self.GCQues.QuesLeaderContent;
    }
    if (!IsStrEmpty(self.TopicPintro)) {
        if (!IsStrEmpty(self.TopicContent)) {
            topicContent = [NSString stringWithFormat:@"%@\n%@",self.TopicPintro,self.TopicContent];
        }else{
            topicContent = self.TopicPintro;
        }
    }else{
        topicContent = self.TopicContent;
    }
    return topicContent;
}
- (NSString *)yj_topicContent{
    return self.TopicContent;
}
- (NSMutableAttributedString *)yj_bigTopicAttrText{
    if (!IsStrEmpty(self.TopicPintro)) {
        NSString *topicPintro = self.TopicPintro;
        if (self.TopicContent_attr) {
            [topicPintro stringByAppendingString:@"\n"];
            [self.TopicContent_attr insertAttributedString:[[NSAttributedString alloc] initWithString:topicPintro] atIndex:0];
        }else{
            self.TopicContent_attr = [[NSMutableAttributedString alloc] initWithString:self.TopicPintro];
        }
    }
    NSInteger userType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    YJTaskStageType taskStateType = [NSUserDefaults yj_integerForKey:UserDefaults_YJTaskStageType];
     if ([self.listenTopicInfo objectForKey:self.TopicTypeID] && !IsStrEmpty(self.AudioResStr) && !IsStrEmpty(self.TopicArticle)) {
         BOOL isShowTopicArticle = NO;
         if (userType == 1) {
             isShowTopicArticle = YES;
         }else if(userType == 2){
             if (taskStateType != YJTaskStageTypeAnswer && taskStateType != YJTaskStageTypeViewer) {
                 isShowTopicArticle = YES;
             }
         }
         if (isShowTopicArticle) {
             [self.TopicContent_attr appendAttributedString:@"\n【听力原文】\n".yj_toMutableAttributedString];
             [self.TopicContent_attr appendAttributedString:self.TopicArticle_attr];
         }
     }
    return self.TopicContent_attr;
}
- (NSString *)yj_topicListenText{
    NSInteger userType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    YJTaskStageType taskStateType = [NSUserDefaults yj_integerForKey:UserDefaults_YJTaskStageType];
    if ([self.listenTopicInfo objectForKey:self.TopicTypeID] && !IsStrEmpty(self.AudioResStr) && !IsStrEmpty(self.TopicArticle)) {
        BOOL isShowTopicArticle = NO;
        if (userType == 1) {
            isShowTopicArticle = YES;
        }else if(userType == 2){
            if (taskStateType != YJTaskStageTypeAnswer && taskStateType != YJTaskStageTypeViewer) {
                isShowTopicArticle = YES;
            }
        }
        if (isShowTopicArticle) {
            return @"听力原文";
        }
    }
    
     return @"";
}

- (BOOL)yj_showTopicKlgInfo{
    NSInteger userType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    YJTaskStageType taskStateType = [NSUserDefaults yj_integerForKey:UserDefaults_YJTaskStageType];
    BOOL isDisplay = NO;
    if (self.klgInfoDisplayEnable) {
        if (userType == 1) {
            isDisplay = YES;
        }else if(userType == 2){
            if (taskStateType != YJTaskStageTypeAnswer && taskStateType != YJTaskStageTypeViewer) {
                isDisplay = YES;
            }
        }
    }
    return isDisplay;
}
- (void)setImport:(NSString *)Import{
    if (!IsStrEmpty(Import)) {
        Import = [Import stringByReplacingOccurrencesOfString:@"<span" withString:[NSString stringWithFormat:@"%@<span",[NSString yj_Char1]]];
        Import = [Import stringByReplacingOccurrencesOfString:@"span>" withString:[NSString stringWithFormat:@"span>%@%@",[NSString stringWithFormat:@"%c",2],[NSString yj_Char1]]];
        Import = Import.yj_toHtmlMutableAttributedString.string;
    }
    _Import = Import;
}
- (void)setMain:(NSString *)Main{
    if (!IsStrEmpty(Main)) {
        Main = [Main stringByReplacingOccurrencesOfString:@"<span" withString:[NSString stringWithFormat:@"%@<span",[NSString yj_Char1]]];
         Main = [Main stringByReplacingOccurrencesOfString:@"span>" withString:[NSString stringWithFormat:@"span>%@%@",[NSString stringWithFormat:@"%c",2],[NSString yj_Char1]]];
        Main = Main.yj_toHtmlMutableAttributedString.string;
    }
    _Main = Main;
}
- (NSString *)yj_topicImpKlgInfo{
    NSString *ImporKnText = @"";
    if (!IsStrEmpty(self.Import)) {
        ImporKnText = [self.Import stringByReplacingOccurrencesOfString:@"|" withString:@"、"];
    }else if (!IsStrEmpty(self.ImporKnText)) {
        ImporKnText = [self.ImporKnText stringByReplacingOccurrencesOfString:@"|" withString:@"、"];
    }
    return ImporKnText;
}
- (NSString *)yj_topicMainKlgInfo{
    NSString *MainKnText = @"";
    if (!IsStrEmpty(self.Main)) {
        MainKnText = [self.Main stringByReplacingOccurrencesOfString:@"|" withString:@"、"];
    }else if (!IsStrEmpty(self.MainKnText)) {
        MainKnText = [self.MainKnText stringByReplacingOccurrencesOfString:@"|" withString:@"、"];
    }
    return MainKnText;
}
- (NSMutableAttributedString *)yj_bigTopicContentAttrText{
    return self.TopicContent_attr;
}
- (void)setTopicArticle:(NSString *)TopicArticle{
    _TopicArticle = TopicArticle;
    _TopicArticle_attr = TopicArticle.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
}
- (NSString *)yj_bigTopicArticle{
    return self.TopicArticle;
}
- (YJBigTopicType)yj_bigTopicType{
    if (!self.yj_topicCarkMode) {
        if ([self isMatch]) {
            return YJBigTopicTypeChioceBlank;
        }else{
            if (IsStrEmpty(self.yj_bigMediaUrl) && IsStrEmpty(self.topicContentInfo)) {
                return YJBigTopicTypeDefault;
            }else if (IsStrEmpty(self.yj_bigMediaUrl) && !IsStrEmpty(self.topicContentInfo)){
                if ([self isBlank]) {
                    return YJBigTopicTypeBigTextAndBlank;
                }else{
                    return YJBigTopicTypeBigText;
                }
            }else if (!IsStrEmpty(self.yj_bigMediaUrl) && IsStrEmpty(self.topicContentInfo)){
                return YJBigTopicTypeListen;
            }else if (!IsStrEmpty(self.yj_bigMediaUrl) && !IsStrEmpty(self.topicContentInfo)){
                return YJBigTopicTypeBigTextAndListen;
            }else{
                return YJBigTopicTypeBigText;
            }
            
        }
    }else{
        if (IsStrEmpty(self.yj_bigMediaUrl) && IsStrEmpty(self.yj_scantronHttp)) {
            return YJBigTopicTypeDefault;
        }else if (IsStrEmpty(self.yj_bigMediaUrl) && !IsStrEmpty(self.yj_scantronHttp)){
            return YJBigTopicTypeBigText;
        }else if (!IsStrEmpty(self.yj_bigMediaUrl) && IsStrEmpty(self.yj_scantronHttp)){
            return YJBigTopicTypeListen;
        }else{
            return YJBigTopicTypeBigTextAndListen;
        }
    }
}
- (NSString *)yj_bigAudioResStr{
    if (IsStrEmpty(self.AudioResStr)) {
        return @"";
    }
    return self.AudioResStr;
}
- (NSString *)yj_bigMediaUrl{
    NSString *mediaUrl = @"";
    if (self.yj_topicCarkMode) {
        mediaUrl = self.yj_scantronAudio;
    }else{
        if ([self.listenTopicInfo objectForKey:self.TopicTypeID] && !IsStrEmpty(self.AudioResStr)) {
        
            NSString *audioResStr = self.AudioResStr;
            if ([audioResStr containsString:[NSString yj_Char1]]) {
                audioResStr = [audioResStr componentsSeparatedByString:[NSString yj_Char1]].firstObject;
            }
            if (self.yj_offline) {
                NSString *audioName = [audioResStr componentsSeparatedByString:@"/"].lastObject;
                NSString *audioPath = [self.yj_offlineFileDir stringByAppendingPathComponent:audioName];
                mediaUrl = audioPath;
            }else{
                mediaUrl = audioResStr;
            }
        }
    }
    return mediaUrl;
}
- (NSArray *)yj_bigMediaUrls{
    if (!IsStrEmpty(self.yj_bigMediaUrl)) {
        NSMutableArray *urls = [NSMutableArray arrayWithObject:self.yj_bigMediaUrl];
        for (YJPaperSmallModel *smallModel in self.Queses) {
            if (!IsStrEmpty(smallModel.QuesAudio)) {
                if (self.yj_offline) {
                  NSString *AudioResName = [self.yj_bigMediaUrl componentsSeparatedByString:@"/"].lastObject;
                    NSString *QuesAudioName = [smallModel.QuesAudio componentsSeparatedByString:@"/"].lastObject;
                    NSString *QuesAudio = [self.yj_bigMediaUrl stringByReplacingOccurrencesOfString:AudioResName withString:QuesAudioName];
                    [urls addObject:QuesAudio];
                }else{
                    [urls addObject:smallModel.QuesAudio];
                }
            }
        }
        return urls;
    }
    return nil;
}
- (NSArray *)yj_bigMediaNames{
    if (!IsStrEmpty(self.yj_bigMediaUrl)) {
        NSMutableArray *names = [NSMutableArray arrayWithObject:@"主音频"];
        for (YJPaperSmallModel *smallModel in self.Queses) {
            if (!IsStrEmpty(smallModel.QuesAudio)) {
                [names addObject:[NSString stringWithFormat:@"(%li)音频",smallModel.yj_smallPaperIndex]];
            }
        }
        return names;
    }
    return nil;
}
- (BOOL)isBlank{
    if ([self.blankTopicInfo objectForKey:self.TopicTypeID]) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isMatch{
    if ([self.matchTopicInfo objectForKey:self.TopicTypeID]) {
        return YES;
    }else{
        return NO;
    }
}
- (NSDictionary<NSString *,NSString *> *)matchTopicInfo{
    if (!IsStrEmpty(self.TopicTypeID) && !IsArrEmpty(self.Queses) && self.Queses.firstObject.AnswerType == 32) {
        return @{self.TopicTypeID:@"匹配题"};
    }
    return @{@"match":@"NO"};
}
- (NSDictionary<NSString *,NSString *> *)listenTopicInfo{
    if (!IsStrEmpty(self.TopicTypeID) && [self.TopicTypeID isEqualToString:@"G"] && !IsStrEmpty(self.AudioResStr)) {
        return @{@"G":@"听力题"};
    }
    return [super listenTopicInfo];
}
- (void)configCorrectAnswerInfo:(NSDictionary *)answerInfo{
    NSMutableArray *keyArr = answerInfo.allKeys.mutableCopy;
    [keyArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [@([obj1 integerValue]) compare:@([obj2 integerValue])];
    }];
    for (int i = 0; i < self.Queses.count; i++) {
        YJPaperSmallModel *smallModel = self.Queses[i];
        if (i > keyArr.count-1) {
            smallModel.yj_smallAnswer = @"";
        }else{
            NSString *key = keyArr[i];
            NSDictionary *dic = [answerInfo objectForKey:key];
            smallModel.yj_smallAnswer = [dic objectForKey:@"result"];
        }
    }
    
    YJPaperSmallModel *smallModel = self.Queses.firstObject;
    NSData *data = [NSJSONSerialization dataWithJSONObject:answerInfo options:NSJSONWritingPrettyPrinted error:nil];
    smallModel.AnswerImgUrlList = @[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}
- (BOOL)yj_isCorrectTopic{
    if ([self.TopicTypeID isEqualToString:@"U"] && self.GCQues && !IsArrEmpty(self.GCQues.ModelTextInfoList)) {
        YJPaperSmallModel *smallModel = self.Queses.firstObject;
        if (!IsArrEmpty(smallModel.AnswerImgUrlList) && !IsStrEmpty(smallModel.AnswerImgUrlList.firstObject)) {
            NSString *answerStr = smallModel.AnswerImgUrlList.firstObject;
            NSData *data = [answerStr dataUsingEncoding:NSUTF8StringEncoding];
            self.GCQues.QuesAnswerInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        return YES;
    }
    return NO;
}
- (YJCorrectModel *)yj_correctModel{
    return self.GCQues;
}
- (NSInteger)yj_bigIndex{
    return self.Index;
}
- (NSInteger)yj_bigBaseIndex{
    return self.TopicIndexEdu;
}
- (NSString *)yj_bigTopicTypeID{
    return self.TopicTypeID;
}
- (NSString *)yj_bigTopicTypeName{
    if (!IsStrEmpty(self.TopicTypeOtherName)) {
        return self.TopicTypeOtherName;
    }
    if (!IsStrEmpty(self.TopicGenreName)) {
        return self.TopicGenreName;
    }
    return self.TopicTypeName;
}
- (NSString *)yj_bigTopicID{
    return self.TopicID;
}
- (NSString *)yj_bigPoolID{
    return [NSString stringWithFormat:@"%@-%li",self.TopicID,self.Index];
}
- (NSString *)yj_bigScore{
    return [NSString stringWithFormat:@"%.1f",self.TopicScore];
}
- (NSArray<NSString *> *)yj_bigChioceBlankAnswerList{
    NSMutableArray *arr = [NSMutableArray array];
    for (YJPaperSmallModel *smallModel in self.Queses) {
        if (IsStrEmpty(smallModel.AnswerStr)) {
            [arr addObject:@""];
        }else{
            [arr addObject:smallModel.AnswerStr];
        }
    }
    return arr;
}
- (NSArray<NSString *> *)yj_bigChioceBlankTopicIndexList{
    NSMutableArray *arr = [NSMutableArray array];
    for (YJPaperSmallModel *smallModel in self.Queses) {
        [arr addObject:[NSString stringWithFormat:@"(%li)",smallModel.yj_smallPaperIndex]];
    }
    return arr;
}
- (NSArray<id<YJPaperSmallProtocol>> *)yj_smallTopicList{
    if ([self isMatch] && self.Queses.count > 1) {
        for (int i = 0; i < self.Queses.count; i++) {
            if (i > 0) {
                YJPaperSmallModel *smallModel = self.Queses[i];
                [smallModel updateOptionContentList:self.Queses.firstObject.OptionContentList optionContentList_attr:self.Queses.firstObject.OptionContentList_attr];
            }
        }
    }
    return self.Queses;
}
- (NSInteger)yj_scoreLookRightQuesCount{
    NSInteger count = 0;
    for (YJPaperSmallModel *smallModel in self.Queses) {
        if (smallModel.StuScore >= smallModel.QuesScore*0.6) {
            count++;
        }
    }
    return count;
}
- (NSString *)yj_scoreLookBigTopicTotalScore{
    CGFloat score = 0;
    for (YJPaperSmallModel *smallModel in self.Queses) {
        score += smallModel.StuScore;
    }
    return [NSString stringWithFormat:@"%.1f",score];
}
- (BOOL)yj_teachAnalysisStage{
    return self.taskStageTypeTeachAnalysis;
}

- (YJSpeechBigTopicType)yj_speechBigTopicType{
    
    if ([self.TopicTypeID isEqualToString:@"SE"] || [self.TopicTypeID hasPrefix:@"SE"]) {
        return YJSpeechBigTopicTypeTalkChoice;
    }else if ([self.TopicTypeID isEqualToString:@"Ssss"]){
        // 听短文待确定 SE前缀 当做听对话处理
        return YJSpeechBigTopicTypeShortChoice;
    }else if ([self.TopicTypeID isEqualToString:@"Sp"]){
        return YJSpeechBigTopicTypeRead;
    }else if ([self.TopicTypeID isEqualToString:@"Sq"]){
        return YJSpeechBigTopicTypeFollowRead;
    }else if ([self.TopicTypeID isEqualToString:@"Ss"]){
         return YJSpeechBigTopicTypeRepeat;
    }else if ([self.TopicTypeID isEqualToString:@"St"]){
        return YJSpeechBigTopicTypeTheme;
    }else if ([self.TopicTypeID isEqualToString:@"Su"]){
        return YJSpeechBigTopicTypeScene;
    }else{
        return YJSpeechBigTopicTypeTalkChoice;
    }
    
}

- (BOOL)yj_offline{
    BOOL isOffline = [NSUserDefaults yj_boolForKey:UserDefaults_YJAnswerOfflineStatus];
    return isOffline;
}
- (NSString *)yj_assignmentID{
    NSString *assignmentID = [NSUserDefaults yj_stringForKey:UserDefaults_YJTaskOfflineAssignmentID];
    if (IsStrEmpty(assignmentID)) {
        return @"";
    }
    return assignmentID;
}
//- (NSString *)yj_offlineFileDir{
//    NSString *savePath= [NSString stringWithFormat:@"%@%@", kDownloadPath.YJ_downloadedPath,[self yj_assignmentID]];
//    return savePath;
//}
- (void)setYj_bigAnswerTimeCount:(NSInteger)yj_bigAnswerTimeCount{
    [super setYj_bigAnswerTimeCount:yj_bigAnswerTimeCount];
    self.AnswerTimeAdd = yj_bigAnswerTimeCount;
}
- (void)setYj_bigAnswerTimeSum:(NSInteger)yj_bigAnswerTimeSum{
    [super setYj_bigAnswerTimeSum:yj_bigAnswerTimeSum];
    self.AnswerTime = yj_bigAnswerTimeSum;
}
@end
@implementation YJPaperModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Topics":[YJPaperBigModel class]};
}
- (void)setHpStuName:(NSString *)HpStuName{
    _HpStuName = HpStuName;
    kHpStuName = HpStuName;
}
- (void)setYj_taskStageType:(YJTaskStageType)yj_taskStageType{
    [super setYj_taskStageType:yj_taskStageType];
    [NSUserDefaults yj_setObject:@(yj_taskStageType) forKey:UserDefaults_YJTaskStageType];
    if (yj_taskStageType == YJTaskStageTypeHp || yj_taskStageType == YJTaskStageTypeHpViewer) {
        int i = 0;
        for (YJPaperBigModel *bigModel in self.Topics) {
            bigModel.Index = i;
            i++;
        }
    }
}
- (NSInteger)LastAnsTopic{
    if (_LastAnsTopic < 0) {
        return 0;
    }
    return _LastAnsTopic;
}
- (NSInteger)LastAnsQues{
    if (_LastAnsQues < 0) {
        return 0;
    }
    return _LastAnsQues;
}
- (void)setYj_currentBigIndex:(NSInteger)yj_currentBigIndex{
    [super setYj_currentBigIndex:yj_currentBigIndex];
    _LastAnsTopic = yj_currentBigIndex;
}
- (void)setYj_taskKlgInfoDisplayEnable:(BOOL)yj_taskKlgInfoDisplayEnable{
    [super setYj_taskKlgInfoDisplayEnable:yj_taskKlgInfoDisplayEnable];
    
    for (YJPaperBigModel *bigModel in self.Topics) {
        bigModel.klgInfoDisplayEnable = yj_taskKlgInfoDisplayEnable;
    }
    
}
- (void)setYj_taskStageTypeTeachAnalysis:(BOOL)yj_taskStageTypeTeachAnalysis{
    [super setYj_taskStageTypeTeachAnalysis:yj_taskStageTypeTeachAnalysis];
    for (YJPaperBigModel *bigModel in self.Topics) {
        bigModel.taskStageTypeTeachAnalysis = yj_taskStageTypeTeachAnalysis;
    }
}

- (void)setTopics:(NSArray<YJPaperBigModel *> *)Topics{
    _Topics = Topics;
     BOOL mutiBlankDisplayEnable = NO;
     for (YJPaperBigModel *bigModel in Topics) {
         if (!IsArrEmpty(bigModel.QuesOri)) {
             mutiBlankDisplayEnable = YES;
             break;
         }
     }
    for (YJPaperBigModel *bigModel in Topics) {
        if (IsStrEmpty(bigModel.TopicContent) && !IsStrEmpty(bigModel.TopicPintro_copy) && [bigModel.TopicPintro_copy containsString:@"<"] && [bigModel.TopicPintro_copy containsString:@">"]) {
            bigModel.TopicContent = bigModel.TopicPintro_copy;
            bigModel.TopicPintro = @"";
        }
       
        CGFloat score = 0;
        CGFloat stuScore = 0;
        for (YJPaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            smallModel.mutiBlankDisplayEnable = mutiBlankDisplayEnable;
            if (smallModel.yj_smallItemCount > 1) {
                NSInteger startIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                NSInteger endIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].lastObject integerValue];
                if (endIndex == 0) {
                    score = 0;
                    stuScore = 0;
                }
                if (endIndex <= smallModel.yj_smallItemCount - 1) {
                    score += smallModel.QuesScore;
                    stuScore += smallModel.StuScore;
                    if (endIndex == smallModel.yj_smallItemCount - 1) {
                        for (NSInteger i = (startIndex + smallModel.yj_smallItemCount - 1); i >= startIndex; i--) {
                            YJPaperSmallModel *lastSmallModel = (YJPaperSmallModel *)bigModel.yj_smallTopicList[i];
                            lastSmallModel.mutiBlankQuesScore = score;
                            lastSmallModel.mutiBlankQuesStuScore = stuScore;
                        }
                    }
                }
            }else{
                smallModel.mutiBlankQuesScore = 0;
            }
            
        }
        
        YJPaperSmallModel *lastSModel = bigModel.Queses.lastObject;
        if (!IsStrEmpty(lastSModel.yj_smallIndex_Ori)) {
            NSInteger smallCount = [[lastSModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue]+1;
            for (int i = 0; i < smallCount; i++) {
                YJPaperSmallModel *iSmallModel = bigModel.Queses[i];
                for (YJPaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
                    NSInteger startIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                    if (startIndex == i) {
                        iSmallModel.mutiBlankIndex = smallModel.Index;
                        break;
                    }
                }
            }
        }
    }
}
- (void)updateMutiBlankScoreInfo{
    for (YJPaperBigModel *bigModel in self.Topics) {
        CGFloat score = 0;
        CGFloat stuScore = 0;
        if (!IsArrEmpty(bigModel.QuesOri)) {
            for (YJPaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
                if (smallModel.yj_smallItemCount > 1) {
                    NSInteger startIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].firstObject integerValue];
                    NSInteger endIndex = [[smallModel.yj_smallIndex_Ori componentsSeparatedByString:@"|"].lastObject integerValue];
                    if (endIndex == 0) {
                        score = 0;
                        stuScore = 0;
                    }
                    if (endIndex <= smallModel.yj_smallItemCount - 1) {
                        score += smallModel.QuesScore;
                        stuScore += smallModel.StuScore;
                        if (endIndex == smallModel.yj_smallItemCount - 1) {
                            for (NSInteger i = (startIndex + smallModel.yj_smallItemCount - 1); i >= startIndex; i--) {
                                YJPaperSmallModel *lastSmallModel = (YJPaperSmallModel *)bigModel.yj_smallTopicList[i];
                                lastSmallModel.mutiBlankQuesScore = score;
                                lastSmallModel.mutiBlankQuesStuScore = stuScore;
                            }
                        }
                    }
                }else{
                    smallModel.mutiBlankQuesScore = 0;
                }
                
            }
        }
    }
}
- (NSArray<id<YJPaperBigProtocol>> *)yj_bigTopicList{
    return self.Topics;
}
- (NSString *)yj_taskScore{
    return [NSString stringWithFormat:@"%.1f",self.TaskTotalScore];
}
- (NSString *)yj_scantronHttp{
    return self.ScantronHttp;
}
- (NSString *)yj_scantronAudio{
    return self.ScantronAudio;
}
- (BOOL)yj_isSubmit{
    return self.isSubmit;
}
- (BOOL)yj_isTopicCardMode{
    if (self.ResOriginTypeID == 27) {
        return YES;
    }
    return NO;
}
- (BOOL)yj_isManualWorkRes{
    if (self.ResOriginTypeID == 34 && !IsStrEmpty(self.ScantronAudio)) {
        return YES;
    }
    return NO;
}
@end
