//
//  YJPaperModel.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJPaperModel.h"
#import "YJConst.h"

static NSString *kHpStuName = @"";
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
    if ([html.lowercaseString hasPrefix:@"<p"] && [html.lowercaseString hasSuffix:@"p>"]) {
        html = [html stringByReplacingOccurrencesOfString:@"<p" withString:@"<strong"];
        html = [html stringByReplacingOccurrencesOfString:@"<P" withString:@"<strong"];
        html = [html stringByReplacingOccurrencesOfString:@"p>" withString:@"strong>"];
        html = [html stringByReplacingOccurrencesOfString:@"P>" withString:@"strong>"];
    }
    if ([html hasSuffix:@"<br>"] || [html hasSuffix:@"<BR>"]) {
        html = [html substringToIndex:html.length-4];
    }
    if ([html hasSuffix:@"</br>"] || [html hasSuffix:@"</BR>"]) {
        html = [html substringToIndex:html.length-5];
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

- (void)setQuesAsk:(NSString *)QuesAsk{
    QuesAsk = [self yj_filterPBrHtml:QuesAsk];
    _QuesAsk = QuesAsk;

//    if (self.yj_offline && [QuesAsk.lowercaseString containsString:@"<img"]) {
//        _QuesAsk_attr = [QuesAsk yj_configOfflineImgAtFilePath:self.yj_offlineFileDir];
//    }else{
        _QuesAsk_attr = QuesAsk.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
//    }
    if (!IsStrEmpty(self.QuesAsk) &&
        [self.QuesAsk containsString:@"____"] &&
        [self.QuesAsk componentsSeparatedByString:@"____"].count > 2) {
        NSArray *arr = [self.QuesAsk componentsSeparatedByString:@" "];
        NSInteger count = 0;
        for (NSString *word in arr) {
            if ([word containsString:@"____"]) {
                count++;
            }
        }
        self.itemCount = count;
    }
}
- (NSInteger)yj_smallItemCount{
    if (self.AnswerType == 2) {
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
    _AnswerStr = AnswerStr;
    self.yj_smallAnswer = AnswerStr;
}

- (NSString *)yj_smallStandardAnswer{
    if (IsStrEmpty(self.QuesAnswer)) {
        return @"-";
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
- (NSInteger)yj_smallPaperIndex{
    return self.PaperIndex;
}
- (NSString *)yj_smallAnswerAnalysis{
    return [NSString yj_filterHTML:self.QuesAnalysis];
}
- (NSString *)yj_smallTopicArticle{
    return self.QuesAudio;
}
- (NSMutableAttributedString *)yj_smallTopicAttrText{
    NSString *index = [NSString stringWithFormat:@"(%li)、",self.PaperIndex];
    NSString *score;
    if (self.yj_smallItemCount > 1) {
        score = [NSString stringWithFormat:@"[%.1f分]",self.QuesScore * self.yj_smallItemCount];
    }else{
        score = [NSString stringWithFormat:@"[%.1f分]",self.QuesScore];
    }
    if (self.QuesAsk_attr) {
        if (![self.QuesAsk_attr.string hasPrefix:index]) {
            [self.QuesAsk_attr insertAttributedString:[[NSAttributedString alloc] initWithString:index] atIndex:0];
            [self.QuesAsk_attr appendAttributedString:[[NSAttributedString alloc] initWithString:score]];
        }
        return self.QuesAsk_attr;
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
- (NSString *)yj_smallIntelligenceScore{
    NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
    if (UserType == 1 && self.AnswerType == 4 && ![self.TopicTypeID isEqualToString:@"f"]) {
        return self.IntelligenceScore;
    }
    return @"";
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
- (NSInteger)yj_smallAnswerType{
    return self.AnswerType;
}


- (void)setYj_smallAnswer:(NSString *)yj_smallAnswer{
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
    if ([self yj_taskStageType] == YJTaskStageTypeCheck) {
        return [NSString stringWithFormat:@"%.1f",self.AnswerScore];
    }else{
        return [NSString stringWithFormat:@"%.1f",self.HpScore];
    }
}
- (NSString *)yj_smallAnswerScore{
    return [NSString stringWithFormat:@"%.1f",self.StuScore];
}
- (void)setYj_smallAnswerScore:(NSString *)yj_smallAnswerScore{
    [super setYj_smallAnswerScore:yj_smallAnswerScore];
    if ([self yj_taskStageType] == YJTaskStageTypeCheck) {
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
    return @[@"hash",@"superclass",@"description",@"debugDescription",@"TopicContent_attr"];
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
    }
}
- (void)setTopicContent:(NSString *)TopicContent{
    _TopicContent = TopicContent;
    _TopicContent_attr = TopicContent.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
}
- (void)setTopicPintro:(NSString *)TopicPintro{
    _TopicPintro = TopicPintro;
    _TopicPintro_copy = TopicPintro;
    if (!IsStrEmpty(TopicPintro)) {
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
        NSString *topicPintro = [NSString stringWithFormat:@"%@\n",self.TopicPintro];
        if (self.TopicContent_attr) {
            [self.TopicContent_attr insertAttributedString:[[NSAttributedString alloc] initWithString:topicPintro] atIndex:0];
        }else{
            self.TopicContent_attr = [[NSMutableAttributedString alloc] initWithString:self.TopicPintro];
        }
    }
    return self.TopicContent_attr;
}
- (NSMutableAttributedString *)yj_bigTopicContentAttrText{
    return self.TopicContent_attr;
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
- (NSArray<id<YJPaperSmallProtocol>> *)yj_smallTopicList{
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
    [NSUserDefaults yj_setObject:@(yj_taskStageType) forKey:@"taskStageType"];
    if (yj_taskStageType == YJTaskStageTypeHp || yj_taskStageType == YJTaskStageTypeHpViewer) {
        int i = 0;
        for (YJPaperBigModel *bigModel in self.Topics) {
            bigModel.Index = i;
            i++;
        }
    }
}
- (void)setYj_currentBigIndex:(NSInteger)yj_currentBigIndex{
    [super setYj_currentBigIndex:yj_currentBigIndex];
    _LastAnsTopic = yj_currentBigIndex;
}

- (void)setTopics:(NSArray<YJPaperBigModel *> *)Topics{
    _Topics = Topics;
    for (YJPaperBigModel *bigModel in Topics) {
        if (IsStrEmpty(bigModel.TopicContent) && !IsStrEmpty(bigModel.TopicPintro_copy) && [bigModel.TopicPintro_copy containsString:@"<"] && [bigModel.TopicPintro_copy containsString:@">"]) {
            bigModel.TopicContent = bigModel.TopicPintro_copy;
            bigModel.TopicPintro = @"";
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
