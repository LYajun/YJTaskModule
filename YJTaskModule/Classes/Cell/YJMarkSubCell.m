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
        make.left.equalTo(self.contentView).offset(10);
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
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.imageBgV];
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(120);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.imageBgV.mas_top).offset(-5);
    }];
    [self.textView yj_clipLayerWithRadius:4 width:0 color:nil];
    
}
- (void)setTitleStr:(NSString *)titleStr{
    self.titleLab.text = titleStr;
     if (IsIPad) {
         if (!IsStrEmpty(titleStr) && [titleStr containsString:@"知识点"]) {
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
- (void)setText:(NSString *)text{
    if (!IsStrEmpty(text) && !IsStrEmpty(text.yj_deleteWhitespaceAndNewlineCharacter) && [text containsString:YJTaskModule_u2060]) {
        text = [text stringByReplacingOccurrencesOfString:YJTaskModule_u2060 withString:@"\n"];
        NSMutableString *textCopy = text.mutableCopy;
        while ([textCopy hasSuffix:@" "] || [textCopy hasSuffix:@"\n"]) {
            if ([textCopy hasSuffix:@" "]) {
                [textCopy deleteCharactersInRange:NSMakeRange(textCopy.length-1, 1)];
            }else if ([textCopy hasSuffix:@"\n"]){
                [textCopy deleteCharactersInRange:NSMakeRange(textCopy.length-2, 2)];
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
        self.textView.textColor = LG_ColorWithHex(0x333333);
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
