//
//  YJTaskTopicCell.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskTopicCell.h"
#import <Masonry/Masonry.h>
#import <TFHpple/TFHpple.h>
#import "YJConst.h"

@interface YJTaskTopicCell ()
@property (nonatomic,strong) UITextView *textView;
@end
@implementation YJTaskTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.userInteractionEnabled = NO;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerX.bottom.equalTo(self.contentView);
    }];
}
- (void)setTopicText:(NSString *)topicText{
    _topicText = topicText;
    self.textView.text = topicText;
}
- (void)setTextAttr:(NSMutableAttributedString *)textAttr{
    _textAttr = textAttr;
    NSMutableAttributedString *attr = textAttr.mutableCopy;
    [attr yj_setFont:16];
    [attr yj_setColor:LG_ColorWithHex(0x252525)];
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attr dataFromRange:NSMakeRange(0,attr.length) documentAttributes:exportParams error:nil];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//table"];
    if (IsArrEmpty(tableArray)) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    }
    self.textView.attributedText = attr;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textColor = [UIColor darkGrayColor];
    }
    return _textView;
}

@end
