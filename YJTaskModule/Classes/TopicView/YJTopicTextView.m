//
//  YJTopicTextView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTopicTextView.h"

#import <YJExtensions/YJEHpple.h>
#import "YJConst.h"
#import <YJExtensions/YJEGumbo+Query.h>
#define kYJTextColor LG_ColorWithHex(0x06C6F4)

@implementation YJTextAttachment
@end

@interface YJBlankTextField : UITextField

@end
@implementation YJBlankTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType =  UITextAutocapitalizationTypeNone;
        self.borderStyle = UITextBorderStyleNone;
        self.clearButtonMode = UITextFieldViewModeNever;
        
        CALayer *line = [[CALayer alloc] init];
        line.backgroundColor = kYJTextColor.CGColor;
        line.frame = CGRectMake(0, frame.size.height -1, frame.size.width, 1);
        [self.layer addSublayer:line];
        [self yj_clipLayerWithRadius:3 width:0 color:nil];
    }
    return self;
}
@end

@interface YJTopicTextView ()
@property (nonatomic, strong) NSMutableArray<YJBlankTextField *> *blankTextFieldArray;
@property (nonatomic, strong) NSMutableArray *blankRangeArray;
@end
@implementation YJTopicTextView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copy:)){
           return YES;
       }
    return NO;
}
- (void)configure{
    self.editable = NO;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.textContainerInset = UIEdgeInsetsZero;//上下间距为零
    _blankTextFieldArray = nil;
    _blankRangeArray = nil;
}
#pragma mark setter
- (void)setBlankAttributedString:(NSAttributedString *)blankAttributedString {
    NSMutableAttributedString *blankAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:blankAttributedString];
    BOOL isFirstUnderLine = YES;
    NSInteger underLineCount = 0;
    for (NSInteger i = 0; i < blankAttrString.string.length; i++) {
        NSString *subStr = [blankAttrString.string substringWithRange:NSMakeRange(i, 1)];
        if ([subStr isEqualToString:@"_"] && isFirstUnderLine == YES) {
            [blankAttrString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",1]];
            isFirstUnderLine = NO;
            underLineCount++;
        }else if ([subStr isEqualToString:@"_"] && isFirstUnderLine == NO) {
            underLineCount++;
            if (underLineCount == 3) {
                [blankAttrString deleteCharactersInRange:NSMakeRange(i, 1)];
                [self.blankRangeArray addObject:@(i)];
                [blankAttrString insertAttributedString:[self blankAttr] atIndex:i];
                if (self.blankRangeArray.count == 1) {
                    YJBlankTextField *textFiled = self.blankTextFieldArray.firstObject;
                    textFiled.backgroundColor = kYJTextColor;
                    textFiled.textColor = [UIColor whiteColor];
                    NSString *placeholder = @"(1)";
                    if (!IsArrEmpty(self.topicIndexs)) {
                        placeholder = self.topicIndexs.firstObject;
                    }
                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:textFiled.font}];
                    textFiled.attributedPlaceholder = attrString;
                    YJTextAttachment *textAttachment = [[YJTextAttachment alloc] initWithData:nil ofType:nil] ;
                    textAttachment.image = [self imageWithUIView:textFiled];
                    textAttachment.textIndex = textFiled.tag;
                    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
                    [blankAttrString replaceCharactersInRange:NSMakeRange(i, 1) withAttributedString:textAttachmentString];
                }
            }else{
                [blankAttrString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",1]];
            }
            continue;
        }else {
            underLineCount = 0;
            isFirstUnderLine = YES;
        }
    }
    [self topicPintroWithAttr:blankAttrString];
    [self obliquenessWithAttr:blankAttrString];
    
    [blankAttrString yj_setFont:kYJTextFontSize];
    [blankAttrString yj_setColor:LG_ColorWithHex(0x252525)];
    if ([blankAttrString.string rangeOfString:@"【听力原文】"].location != NSNotFound) {
        [blankAttrString yj_setColor:LG_ColorWithHex(0xb06223) atRange:[blankAttrString.string rangeOfString:@"【听力原文】"]];
    }
    
    [self strongWithAttr:blankAttrString];
    
    [self tableWithAttr:blankAttrString];
    self.attributedText = blankAttrString;
}
- (void)setTopicContentAttr:(NSAttributedString *)topicContentAttr{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:topicContentAttr];
    [self topicPintroWithAttr:attr];
    [self obliquenessWithAttr:attr];
    
    [attr yj_setFont:kYJTextFontSize];
    [attr yj_setColor:LG_ColorWithHex(0x252525)];
    if ([attr.string rangeOfString:@"【听力原文】"].location != NSNotFound) {
        [attr yj_setColor:LG_ColorWithHex(0xb06223) atRange:[attr.string rangeOfString:@"【听力原文】"]];
    }
   
    
    [self strongWithAttr:attr];
    
    [self tableWithAttr:attr];
    
    self.attributedText = attr;
}
- (void)topicPintroWithAttr:(NSMutableAttributedString *)attr{
    if (!IsStrEmpty(self.topicPintro)) {
        NSString *textAttrStr = attr.string;
        NSRange range = [textAttrStr rangeOfString:self.topicPintro];
        if (range.location != NSNotFound) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = kYJTextLineSpacing;
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }
}
- (void)tableWithAttr:(NSMutableAttributedString *)attr{
    if (!IsStrEmpty(self.topicContent) && ![self.topicContent containsString:@"style=\""]) {
        NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
        NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
        YJEHpple *xpathParser = [[YJEHpple alloc] initWithHTMLData:htmlData];
        NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
        if (IsArrEmpty(tableArray)) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = kYJTextLineSpacing;
            [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
        }
    }
}
- (void)strongWithAttr:(NSMutableAttributedString *)attr{
    if (!IsStrEmpty(self.topicContent) && [self.topicContent.lowercaseString containsString:@"<strong"]) {
        YJEGumboDocument *document = [[YJEGumboDocument alloc] initWithHTMLString:self.topicContent];
        NSArray *elements = document.Query(@"strong");
        for (YJEGumboElement *element in elements) {
            NSString *text = [element.text() yj_deleteWhitespaceAndNewlineCharacter];
            if (!IsStrEmpty(text)) {
                NSString *textAttrStr = attr.string;
                NSRange range = [textAttrStr rangeOfString:text];
                if (range.location != NSNotFound) {
                    [attr yj_setBoldFont:17 atRange:range];
                    NSString *class = kApiParams(element.attr(@"class"));
                    if ([class isEqualToString:@"Ques-title"]) {
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.alignment = NSTextAlignmentCenter;
                        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
                    }
                }
            }
        }
    }
}
- (void)obliquenessWithAttr:(NSMutableAttributedString *)attr{
    YJEGumboDocument *document = [[YJEGumboDocument alloc] initWithHTMLString:self.topicContent];
       NSArray *elements1 = document.Query(@"i");
       NSArray *elements2 = document.Query(@"em");
       NSMutableArray *elements = [NSMutableArray array];
       if (!IsArrEmpty(elements1)) {
           [elements addObjectsFromArray:elements1];
       }
       if (!IsArrEmpty(elements2)) {
           [elements addObjectsFromArray:elements2];
          }
       for (YJEGumboElement *element in elements) {
           NSString *text = [element.text() yj_deleteWhitespaceAndNewlineCharacter];
           if (!IsStrEmpty(text)) {
               NSString *textAttrStr = attr.string;
               NSRange range = [textAttrStr rangeOfString:text];
               if (range.location != NSNotFound) {
                  [attr addAttribute:NSObliquenessAttributeName value:@(0.3) range:range];
               }
           }
       }
}
- (void)setCurrentSmallIndex:(NSInteger)currentSmallIndex{
    _currentSmallIndex = currentSmallIndex;
    if (IsArrEmpty(self.blankRangeArray)) {
        return;
    }
    [self scrollRangeToVisible:NSMakeRange([self.blankRangeArray[currentSmallIndex] integerValue], 1)];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // 匹配题容错处理
    NSInteger count = self.answerResults.count;
    for (NSInteger i = 0; i < count; i++) {
        YJBlankTextField *textFiled = self.blankTextFieldArray[i];
        NSString *placeholder = [NSString stringWithFormat:@"(%li)",i+1];
         if (!IsArrEmpty(self.topicIndexs) && i <= self.topicIndexs.count-1) {
             placeholder = [self.topicIndexs yj_objectAtIndex:i];
         }
        UIColor *placeholderColor;
        if (i == currentSmallIndex) {
            textFiled.backgroundColor = kYJTextColor;
            textFiled.textColor = [UIColor whiteColor];
            placeholderColor = [UIColor whiteColor];
        }else{
            textFiled.backgroundColor = [UIColor whiteColor];
            textFiled.textColor = kYJTextColor;
            placeholderColor = kYJTextColor;
        }
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor,NSFontAttributeName:textFiled.font}];
        textFiled.attributedPlaceholder = attrString;
        YJTextAttachment *textAttachment = [[YJTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = [self imageWithUIView:textFiled];
        textAttachment.textIndex = textFiled.tag;
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        NSMutableAttributedString *imageString = [[NSMutableAttributedString alloc] initWithAttributedString:textAttachmentString];
        [attr replaceCharactersInRange:NSMakeRange([self.blankRangeArray[i] integerValue], 1) withAttributedString:imageString];
    }
    self.attributedText = attr;
    
}

- (void)setAnswerResults:(NSArray<NSString *> *)answerResults{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // 匹配题容错处理
    NSInteger count = answerResults.count > self.blankTextFieldArray.count ? self.blankTextFieldArray.count : answerResults.count;
    for (NSInteger i = 0; i < count; i++) {
        YJBlankTextField *textFiled = self.blankTextFieldArray[i];
        NSString *answer = answerResults[i];
        if (!IsStrEmpty(answer) && !IsStrEmpty(textFiled.placeholder)) {
            answer = [NSString stringWithFormat:@"%@.%@",textFiled.placeholder,answer];
        }
        textFiled.text = answer;
        YJTextAttachment *textAttachment = [[YJTextAttachment alloc] initWithData:nil ofType:nil] ;
        textAttachment.image = [self imageWithUIView:textFiled];
        textAttachment.textIndex = textFiled.tag;
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        NSMutableAttributedString *imageString = [[NSMutableAttributedString alloc] initWithAttributedString:textAttachmentString];
        [attr replaceCharactersInRange:NSMakeRange([self.blankRangeArray[i] integerValue], 1) withAttributedString:imageString];
    }
    self.scrollEnabled = NO;
    self.attributedText = attr;
    self.scrollEnabled = YES;
}

#pragma mark getter
- (NSArray<NSString *> *)answerResults{
    NSMutableArray *blankAnswers = [NSMutableArray array];
    for (YJBlankTextField *textField in self.blankTextFieldArray) {
        [blankAnswers  addObject:textField.text];
    }
    return blankAnswers.copy;
}
// 填空题富文本
- (NSMutableAttributedString *)blankAttr{
    YJBlankTextField *btn = [[YJBlankTextField alloc] initWithFrame:CGRectMake(0, 0, 70, 22)];
    btn.font = [UIFont systemFontOfSize:kYJTextFontSize-2];
    btn.tag = self.blankTextFieldArray.count;
    [self.blankTextFieldArray addObject:btn];
    NSString *placeholder = [NSString stringWithFormat:@"(%li)",self.blankTextFieldArray.count];
    if (!IsArrEmpty(self.topicIndexs) && self.topicIndexs.count >= self.blankTextFieldArray.count) {
        placeholder = [self.topicIndexs yj_objectAtIndex:self.blankTextFieldArray.count-1];
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:kYJTextColor,NSFontAttributeName:btn.font}];
    btn.attributedPlaceholder = attrString;
    btn.textColor = kYJTextColor;
    YJTextAttachment *textAttachment = [[YJTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = [self imageWithUIView:btn];
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    NSMutableAttributedString *imageString = [[NSMutableAttributedString alloc] initWithAttributedString:textAttachmentString];
    textAttachment.textIndex = btn.tag;
    return imageString;
}
- (UIImage*)imageWithUIView:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (NSInteger)totalBlankCount{
    return self.blankTextFieldArray.count;
}
- (NSMutableArray<YJBlankTextField *> *)blankTextFieldArray
{
    if(!_blankTextFieldArray){
        _blankTextFieldArray = [NSMutableArray array];
    }
    return _blankTextFieldArray;
}
- (NSMutableArray *)blankRangeArray{
    if (!_blankRangeArray) {
        _blankRangeArray = [NSMutableArray array];
    }
    return _blankRangeArray;
}
@end
