//
//  YJTaskModel.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJTaskModel.h"
#import <YJExtensions/YJEHpple.h>
#import "YJConst.h"

@implementation YJTaskCourResModel

@end

@interface YJTaskModel ()
@property (nonatomic,strong) NSMutableDictionary *htmlDic;
@property (nonatomic,strong) NSString *answerStrCopy;
@end
@implementation YJTaskModel
+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"hash",@"superclass",@"description",@"debugDescription",@"AnswerStr_Attr"];
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"CourResList":[YJTaskCourResModel class]
             };
}
- (BOOL)isVideoRes{
    return YJTaskSupportVideoType(_ResFileExtension);
}

- (BOOL)isMusicRes{
    return YJTaskSupportAudioType(_ResFileExtension);
}
- (NSMutableDictionary *)htmlDic{
    if (!_htmlDic) {
        _htmlDic = [NSMutableDictionary dictionary];
    }
    return _htmlDic;
}
- (void)initImgInfoWithHtmlAttr:(NSAttributedString *) htmlAttr{
    NSString *html = [self yj_htmlBodyContentWithHtmlAttributedText:htmlAttr];
    NSArray *imgArr = [self imgArrayByHtmlStr:self.AnswerStr];
    NSArray *bodyImgArr = [self imgArrayByHtmlStr:html];
    if (!IsArrEmpty(bodyImgArr)) {
        for (int i = 0; i < bodyImgArr.count; i++) {
            YJEHppleElement *hppleElement = imgArr[i];
            YJEHppleElement *bodyHppleElement = bodyImgArr[i];
            [self.htmlDic setObject:hppleElement.attributes forKey:[bodyHppleElement.attributes objectForKey:@"src"]];
        }
    }
}
- (void)configAnswerStr:(NSString *)htmlStr{
    NSArray *imgArr = [self imgArrayByHtmlStr:htmlStr];
    if (!IsArrEmpty(imgArr)) {
        for (int i = 0; i < imgArr.count; i++) {
            YJEHppleElement *hppleElement = imgArr[i];
            NSDictionary *attrDic = hppleElement.attributes;
            NSString *str1 = [NSString stringWithFormat:@"<img src=\"%@\" alt=\"%@\"/>",attrDic[@"src"],attrDic[@"alt"]];
            NSDictionary *attrDic2 = self.htmlDic[attrDic[@"src"]];
            NSString *width;
            NSString *height;
            if ([[attrDic2 allKeys] containsObject:@"width"]) {
                width = attrDic2[@"width"];
                height = attrDic2[@"height"];
            }else{
                width = [NSString stringWithFormat:@"%.f",LG_ScreenWidth-30];
                height = width;
            }
            NSString *str2 = [NSString stringWithFormat:@"<img class=\"myInsertImg\" src=\"%@\" width=\"%@\" height=\"%@\"/>",attrDic2[@"src"],width,height];
            htmlStr = [htmlStr stringByReplacingOccurrencesOfString:str1 withString:str2];
        }
    }
    _AnswerStr = htmlStr;
}
- (NSArray *)imgArrayByHtmlStr:(NSString *) htmlStr{
    NSData *htmlData = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 解析html数据
    YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
    // 根据标签来进行过滤
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    return imgArray;
}
- (void)setHtmlValueDic:(NSDictionary *) valueDic htmlAttr:(NSAttributedString *) htmlAttr{
    NSString *html = [self yj_htmlBodyContentWithHtmlAttributedText:htmlAttr];
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    if (!IsArrEmpty(imgArray)) {
        YJEHppleElement *hppleElement = imgArray.firstObject;
        NSDictionary *attributes = hppleElement.attributes;
        NSString *src = [attributes objectForKey:@"src"];
        [self.htmlDic setObject:valueDic forKey:src];
    }
}
- (NSString *)yj_htmlBodyContentWithHtmlAttributedText:(NSAttributedString *) attributedText{
    NSString *html = nil;
    if (attributedText && attributedText.length > 0) {
        NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
        NSData *htmlData = [attributedText dataFromRange:NSMakeRange(0,attributedText.length) documentAttributes:exportParams error:nil];
        YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
        NSArray *bodyArray = [xpathParser searchWithXPathQuery:@"//body"];
        if (!IsArrEmpty(bodyArray)) {
            YJEHppleElement *hppleElement = bodyArray.firstObject;
            html = hppleElement.raw;
            html = [html stringByReplacingOccurrencesOfString:@"<body>" withString:@""];
            html = [html stringByReplacingOccurrencesOfString:@"</body>" withString:@""];
        }
    }
    return html;
}
- (void)submitUpdateAnswerStr:(NSString *)AnswerStr{
    _AnswerStr = AnswerStr;
}
- (void)setAnswerStr:(NSString *)AnswerStr{
    _AnswerStr = AnswerStr;
    if (IsStrEmpty(AnswerStr)) {
        return;
    }
    _AnswerStr_Attr = AnswerStr.yj_htmlImgFrameAdjust.yj_toHtmlMutableAttributedString;
    [_AnswerStr_Attr yj_setFont:16];
    [self initImgInfoWithHtmlAttr:_AnswerStr_Attr];
}

- (NSString *)bkFtpRelativePath{
    NSString *ftpFileName = [self.FtpPath componentsSeparatedByString:@"/"].lastObject;
    NSString *ftpPath = [self.FtpPath stringByReplacingOccurrencesOfString:ftpFileName withString:@""];
    return [self.bkSpeechConfig.VirtualPath stringByAppendingPathComponent:ftpPath];
}
@end
