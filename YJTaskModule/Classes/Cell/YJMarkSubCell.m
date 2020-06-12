//
//  YJMarkSubCell.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/29.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJMarkSubCell.h"
#import "LGBaseTextView.h"
#import <LGTalk/LGTPhotoBrowser.h>
#import <Masonry/Masonry.h>
#import "YJConst.h"
#import <YJExtensions/YJEGumbo+Query.h>

@interface YJMarkSubCell ()
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) LGBaseTextView *textView;

@property (strong, nonatomic) UIView *imageBgV;
@property (strong,nonatomic) LGTPhotoBrowser *photoBrowser;
@end
@implementation YJMarkSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (IsIPad) {
            [self layoutUI_ipad];
        }else{
            [self layoutUI];
        }
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(4);
        make.top.equalTo(self.contentView).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.imageBgV];
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(120);
    }];
    
   [self.contentView insertSubview:self.textView belowSubview:self.titleLab];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.imageBgV.mas_top).offset(-5);
        
    }];
    [self.textView yj_clipLayerWithRadius:4 width:0 color:nil];
}
- (void)layoutUI_ipad{
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.imageBgV];
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(120);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.imageBgV.mas_top).offset(-5);
    }];
    [self.textView yj_clipLayerWithRadius:4 width:0 color:nil];
    
}
- (void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
     if (IsIPad) {
         if (!IsStrEmpty(titleStr) && [titleStr containsString:@"考点"]) {
             CGFloat width = [titleStr yj_widthWithFont:LG_SysFont(16)]+5;
             [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(width);
             }];
         }
     }
}
- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLab.textColor = titleColor;
}
- (void)setTextAttr:(NSAttributedString *)textAttr{
    NSMutableAttributedString *attr = textAttr.mutableCopy;
    [attr yj_setFont:17];
    [attr yj_setColor:LG_ColorWithHex(0x333333)];
    
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
    
    self.textView.attributedText = attr;
}
- (void)setText:(NSString *)text{
    NSArray *pianzhangAnswerArr = nil;
    
    if (!IsStrEmpty(text) && !IsStrEmpty(text.yj_deleteWhitespaceAndNewlineCharacter) && [text containsString:YJTaskModule_u2060]) {
        pianzhangAnswerArr = [text componentsSeparatedByString:YJTaskModule_u2060];
        text = [text stringByReplacingOccurrencesOfString:YJTaskModule_u2060 withString:@"\n"];
        NSMutableString *textCopy = text.mutableCopy;
        while ([textCopy hasSuffix:@" "] || [textCopy hasSuffix:@"\n"]) {
            if ([textCopy hasSuffix:@" "]) {
                [textCopy deleteCharactersInRange:NSMakeRange(textCopy.length-1, 1)];
            }else if ([textCopy hasSuffix:@"\n"]){
                [textCopy deleteCharactersInRange:NSMakeRange(textCopy.length-1, 1)];
            }
        }
        text = textCopy;
    }
    self.textView.text = text;
    if (IsIPad) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(IsStrEmpty(text) ? -30 :5);
        }];
    }else{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(IsStrEmpty(text) ? -30 :5);
        }];
    }
    if (!IsStrEmpty(text) && [text isEqualToString:@"未作答"]) {
        self.textView.textColor = LG_ColorWithHex(0x999999);
    }else{
        
        if (!IsArrEmpty(pianzhangAnswerArr)) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
            for (int i = 0;i < pianzhangAnswerArr.count;i++) {
                NSString *pianzhang = pianzhangAnswerArr[i];
                NSString *pianzhangAnswer = pianzhang.yj_deleteWhitespaceAndNewlineCharacter;
                BOOL unAnswer = NO;
                if (IsStrEmpty(pianzhangAnswer)) {
                    unAnswer = YES;
                    pianzhangAnswer = @"未作答";
                }
                NSMutableAttributedString *pianzhangAttr = [NSString stringWithFormat:@"%@%@",pianzhangAnswer,(i < pianzhangAnswerArr.count-1 ? @"\n" : @"")].yj_toMutableAttributedString;
                if (unAnswer) {
                    [pianzhangAttr yj_setColor:LG_ColorWithHex(0x989898)];
                }else{
                    [pianzhangAttr yj_setColor:LG_ColorWithHex(0x333333)];
                }
                NSMutableAttributedString *indexAttr = [NSString stringWithFormat:@"%@ ",[NSString yj_stringToSmallTopicIndexStringWithIntCount:i]].yj_toMutableAttributedString;
                [indexAttr yj_setColor:LG_ColorWithHex(0x333333)];
                [indexAttr appendAttributedString:pianzhangAttr];
                [attr appendAttributedString:indexAttr];
            }
            [attr yj_setFont:16];
            self.textView.attributedText = attr;
        }else{
            NSMutableArray *spanTextArray = [NSMutableArray array];
            if ([text containsString:[NSString yj_Char1]]) {
                NSArray *char1Arr = [text componentsSeparatedByString:[NSString yj_Char1]];
                for (int i = 0; i < char1Arr.count-1; i++) {
                    if (i > 0) {
                        NSString *spanText = char1Arr[i];
                        if (!IsStrEmpty(spanText) && [spanText hasSuffix:[NSString stringWithFormat:@"%c",2]]) {
                            [spanTextArray addObject:spanText];
                        }
                    }
                }
            }
            if (spanTextArray.count > 0) {
                NSMutableAttributedString *attr = text.yj_toMutableAttributedString;
                [attr yj_setFont:16];
                [attr yj_setColor:LG_ColorWithHex(0x333333)];
                for (NSString *spanText in spanTextArray) {
                    NSRange range = [attr.string rangeOfString:spanText];
                    if (range.location != NSNotFound) {
                        [attr yj_setBoldFont:17 atRange:range];
                        [attr yj_setColor:LG_ColorWithHex(0x252525) atRange:range];
                    }
                }
                self.textView.attributedText = attr;
            }else{
                self.textView.textColor = LG_ColorWithHex(0x333333);
            }
        }
        
        
    }
}
- (void)setIsAddBgColor:(BOOL)isAddBgColor{
    _isAddBgColor = isAddBgColor;
    if (isAddBgColor) {
        self.textView.backgroundColor = LG_ColorWithHex(0xDFEFFE);
    }else{
        self.textView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setImgUrlArr:(NSArray *)imgUrlArr{

    _imgUrlArr = imgUrlArr;
    
    if (IsArrEmpty(imgUrlArr)) {
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        CGFloat imageBgW = self.photoBrowserWidth;
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageBgW/3);
        }];
        self.photoBrowser.imageUrls = imgUrlArr;
    }
}
- (CGFloat)photoBrowserWidth{
    if (IsIPad) {
        return 120*3;
    }
    return  LG_ScreenWidth - 10 - 10;;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = LG_SysFont(16);
    }
    return _titleLab;
}
- (LGBaseTextView *)textView{
    if (!_textView) {
        _textView = [LGBaseTextView new];
        _textView.placeholder = [NSString yj_Char1];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        _textView.font = LG_SysFont(16);
        _textView.textColor = LG_ColorWithHex(0x333333);
    }
    return _textView;
}
- (LGTPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        CGFloat imageBgW = self.photoBrowserWidth;
        _photoBrowser = [[LGTPhotoBrowser alloc] initWithFrame:CGRectZero width:imageBgW];
        [self.imageBgV addSubview:_photoBrowser];
        [_photoBrowser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageBgV);
        }];
    }
    return _photoBrowser;
}
- (UIView *)imageBgV{
    if (!_imageBgV) {
        _imageBgV = [UIView new];
    }
    return _imageBgV;
}
@end
