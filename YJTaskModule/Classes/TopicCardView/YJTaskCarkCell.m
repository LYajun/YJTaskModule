//
//  YJTaskCarkCell.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskCarkCell.h"
#import "YJTaskCardItem.h"
#import "YJTaskCarkModel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

static CGFloat kTaskCarkCellWidthRate = 0.9;
@interface YJTaskCarkCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *titleL;
@end
@implementation YJTaskCarkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    UIView *titleView = [UIView new];
    titleView.backgroundColor = LG_ColorWithHex(0xe2eff4);
    [self.contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    [titleView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(titleView);
        make.left.equalTo(titleView).offset(20);
    }];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(titleView.mas_bottom);
         make.bottom.equalTo(self.contentView).offset(-3);
    }];
    
    [titleView addSubview:self.curentImage];
    [self.curentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.titleL.mas_left);
        make.width.height.mas_equalTo(8);
    }];
    
}
- (void)setCardModel:(YJTaskCarkModel *)cardModel{
    _cardModel = cardModel;
    NSAttributedString *attr = [NSMutableAttributedString yj_AttributedStringByHtmls:@[[NSString stringWithFormat:@"第%li大题",cardModel.topicIndex+1],[NSString stringWithFormat:@"  %@",cardModel.topcTypeName]] colors:@[LG_ColorWithHex(0x429fc5),LG_ColorWithHex(0x429fc5)] fonts:@[@(16),@(16)]];
    self.titleL.attributedText = attr;
    [self.collectionView reloadData];
}
#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cardModel.answerResults.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJTaskCardItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJTaskCardItem class]) forIndexPath:indexPath];
    cell.index = [self.cardModel.indexs[indexPath.row] integerValue];
    cell.isFinishAnswer = [self.cardModel.answerResults[indexPath.row] boolValue];
    if (!IsStrEmpty(self.currentSmallIndexStr) && indexPath.row == self.currentSmallIndexStr.integerValue) {
        if (self.isTopicCardMode) {
            cell.isCurrentTopic = NO;
        }else{
            cell.isCurrentTopic = YES;
        }
    }else{
        cell.isCurrentTopic = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.SelectItemBlock) {
        self.SelectItemBlock(indexPath.row);
    }
}
- (UIImageView *)curentImage{
    if (!_curentImage) {
        _curentImage = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"lg_answer_card_sanjiao" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
        _curentImage.hidden = YES;
    }
    return _curentImage;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        layout.minimumInteritemSpacing = 3;
        layout.minimumLineSpacing = 3;
        CGFloat w = (LG_ScreenWidth*kTaskCarkCellWidthRate-20*2-3*5)/5;
        layout.itemSize = CGSizeMake(w, w);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[YJTaskCardItem class] forCellWithReuseIdentifier:NSStringFromClass([YJTaskCardItem class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
@end
