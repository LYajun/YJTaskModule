//
//  YJMemberListCell.m
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "YJMemberListCell.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>

@interface YJMemberListCell ()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *selImgV;
@end
@implementation YJMemberListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.selImgV];
    [self.selImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.selImgV.mas_left).offset(-10);
    }];
}
- (void)setName:(NSString *)name{
    _name = name;
    self.nameLab.text = name;
}
- (void)setChoice:(BOOL)choice{
    _choice = choice;
    self.selImgV.hidden = !choice;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.textColor = LG_ColorWithHex(0x00C891);
        _nameLab.font = LG_SysFont(16);
    }
    return _nameLab;
}
- (UIImageView *)selImgV{
    if (!_selImgV) {
        _selImgV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"select" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()]];
    }
    return _selImgV;
}
@end





@interface YJTaskSearchBar ()

@property (nonatomic,copy) NSString *searchString;
@property (nonatomic, strong) UIToolbar *customAccessoryView;
@end

@implementation YJTaskSearchBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}
- (void)config{
    self.backgroundColor = LG_ColorWithHex(0xededed);
    self.inputAccessoryView = self.customAccessoryView;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"search" atDir:YJTaskBundle_SpeechAnswer atBundle:YJTaskBundle()]];
    imageView.contentMode = UIViewContentModeCenter;

    self.tintColor = [UIColor lightGrayColor];
    self.placeholder = @"请输入关键字搜索...";
    self.font = [UIFont systemFontOfSize:14];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeyDone;

}
- (void)clearAction{
    self.text = @"";
    if (self.removeBlock) {
        self.removeBlock();
    }
}
- (void)done{
    [self resignFirstResponder];
}
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,width,40}];
        _customAccessoryView.barTintColor = [UIColor whiteColor];
        UIBarButtonItem *clear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[clear,space,finish]];
        
    }
    return _customAccessoryView;
}

@end
