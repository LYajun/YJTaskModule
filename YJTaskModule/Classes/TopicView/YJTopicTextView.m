//
//  YJTopicTextView.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTopicTextView.h"

#import <TFHpple/TFHpple.h>
#import "YJConst.h"

#define kYJTextColor LG_ColorWithHex(0x06C6F4)
static CGFloat kYJTextFontSize = 16;
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
    return NO;
}
- (void)configure{
    self.editable = NO;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
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
    
    [blankAttrString yj_setFont:kYJTextFontSize];
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [blankAttrString dataFromRange:NSMakeRange(0,blankAttrString.length) documentAttributes:exportParams error:nil];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
    if (IsArrEmpty(tableArray)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        [blankAttrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, blankAttrString.length)];
    }
    self.attributedText = blankAttrString;
}
- (void)setTopicContentAttr:(NSAttributedString *)topicContentAttr{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:topicContentAttr];
    [attr yj_setFont:kYJTextFontSize];
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
    if (IsArrEmpty(tableArray)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    }
    
    self.attributedText = attr;
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
        textFiled.text = answerResults[i];
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
