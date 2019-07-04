//
//  YJListenListView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/8/29.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJListenListView.h"
#import "LGBaseTableViewCell.h"

#import <Masonry/Masonry.h>
#import "YJConst.h"


@interface YJListenlistCell : LGBaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *imageV;
@end
@implementation YJListenlistCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutViews];
    }
    return self;
}
- (void)layoutViews{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.height.mas_equalTo(20);
    }];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.imageV.mas_left).offset(-20);
        make.left.equalTo(self.contentView).offset(10);
    }];
}
- (void)setTitleStr:(NSString *) titleStr{
    self.titleL.text = titleStr;
}
- (void)setCurrentSelected:(BOOL) isSel{
    self.imageV.hidden = !isSel;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textColor = LG_ColorWithHex(0x252525);
        _titleL.font = LG_SysFont(16);
    }
    return _titleL;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"listen_list_sel" atDir:YJTaskBundle_ListenView atBundle:YJTaskBundle()]];
    }
    return _imageV;
}
@end

@interface YJListenListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *maskView;

@end
@implementation YJListenListView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutViews];
        [self configure];
    }
    return self;
}
- (void)configure {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LG_ColorWithHex(0x0aa9fb).CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1.5;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.masksToBounds = NO;
}
- (void)layoutViews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.centerX.equalTo(self);
    }];
}
- (void)setListenTitles:(NSArray<NSString *> *)listenTitles{
    _listenTitles = listenTitles;
    [self.tableView reloadData];
}
+ (YJListenListView *)showOnView:(UIView *)view frame:(CGRect)frame{
    YJListenListView *listView = [[YJListenListView alloc] initWithFrame:frame];
    listView.maskView = [[UIView alloc] initWithFrame:view.bounds];
    listView.maskView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:listView action:@selector(hide)];
    [listView.maskView addGestureRecognizer:tap];
    [view addSubview:listView.maskView];
    [view addSubview:listView];
    return listView;
}
- (void)show{
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.3 animations:^(void) {
//        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(self.height);
//        }];
//    }];
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^(void) {
        weakSelf.maskView.alpha = 0;
    } completion:^(BOOL isFinished) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(YJListenListViewDidHide)]) {
        [self.delegate YJListenListViewDidHide];
    }
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listenTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJListenlistCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJListenlistCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.currentIndex) {
        [cell setCurrentSelected:YES];
    }else{
         [cell setCurrentSelected:NO];
    }
    cell.separatorOffset = 10;
    cell.sepColor = LG_ColorWithHex(0x0aa9fb);
    if (indexPath.row < self.listenTitles.count-1) {
         cell.isShowSeparator = YES;
    }else{
        cell.isShowSeparator = NO;
    }
    [cell setTitleStr:self.listenTitles[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.currentIndex) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(YJListenListView:didSelectedItemAtIndex:)]) {
            [self.delegate YJListenListView:self didSelectedItemAtIndex:indexPath.row];
        }
    }
    [self hide];
}
#pragma mark Property init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[YJListenlistCell class] forCellReuseIdentifier:NSStringFromClass([YJListenlistCell class])];
    }
    return _tableView;
}
@end
