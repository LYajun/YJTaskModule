//
//  YJTopicCarkChoiceAnswerCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2018/5/14.
//  Copyright © 2018年 lange. All rights reserved.
//

#import "YJTopicCarkChoiceAnswerCell.h"
#import "YJImageLabel.h"
#import "YJConst.h"
#import <Masonry/Masonry.h>

#pragma mark -
static CGFloat indexLabHeight = 36;
@interface YJTopicCarkChoiceAnswerItemCellLab : YJImageLabel
@property (nonatomic,assign) BOOL isChoice;
@property (nonatomic,assign) NSInteger topicIndex;
@end
@implementation YJTopicCarkChoiceAnswerItemCellLab

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}
- (void)configure{
    [self yj_clipLayerWithRadius:indexLabHeight/2 width:0 color:nil];
    self.textColor = LG_ColorThemeBlue;
    self.bgImageName = @"lg_choice_n";
}
- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;
    [self setupChoiceStatus];
}
- (void)setupChoiceStatus{
    if (self.isChoice) {
        self.textColor = [UIColor whiteColor];
        self.bgImageName = @"lg_choice_s";
    }else{
        self.textColor = LG_ColorWithHex(0x252525);;
        self.bgImageName = @"lg_choice_n";
    }
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    _topicIndex = topicIndex;
    self.textStr = self.topicIndexTitle;
}
- (NSString *)topicIndexTitle{
    // ascll码转化
    return [NSString stringWithFormat:@"%c",(int)self.topicIndex+65];
}
@end

#pragma mark -

@interface YJTopicCarkChoiceAnswerItemCell:UICollectionViewCell
@property (nonatomic,strong)YJTopicCarkChoiceAnswerItemCellLab *numL;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger topicIndex;
@end
@implementation YJTopicCarkChoiceAnswerItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.numL];
        [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(indexLabHeight);
        }];
    }
    return self;
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.numL.isChoice = isSelected;
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    _topicIndex = topicIndex;
    self.numL.topicIndex = topicIndex;
}
- (YJTopicCarkChoiceAnswerItemCellLab *)numL{
    if (!_numL) {
        _numL = [[YJTopicCarkChoiceAnswerItemCellLab alloc] initWithFrame:CGRectZero];
        _numL.fontSize = 18;
    }
    return _numL;
}
@end

@interface YJTopicCarkChoiceAnswerCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *indexLab;
@property (nonatomic,assign) NSInteger choiceIndex;
@end
@implementation YJTopicCarkChoiceAnswerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self.contentView addSubview:self.indexLab];
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(35);
    }];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(4);
        make.left.equalTo(self.indexLab.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
}
- (void)setTopicCount:(NSInteger)topicCount{
    _topicCount = topicCount;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (topicCount%4 == 0) {
            make.height.mas_greaterThanOrEqualTo(40 * topicCount/4);
        }else{
             make.height.mas_greaterThanOrEqualTo(40 + 40 * topicCount/4);
        }
    }];
    [self.collectionView reloadData];
}
- (void)setTopicIndex:(NSInteger)topicIndex{
    _topicIndex = topicIndex;
    self.indexLab.text = [NSString stringWithFormat:@"(%li)",topicIndex];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topicCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJTopicCarkChoiceAnswerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerItemCell class]) forIndexPath:indexPath];
    cell.topicIndex  = indexPath.row;
    NSInteger index = -1;
    if (!IsStrEmpty(self.answer)) {
       index = self.answer.yj_stringToASCIIInt-65;
    }
    if (index == indexPath.row) {
        cell.isSelected = YES;
        self.choiceIndex  = indexPath.row;
    }else{
        cell.isSelected = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YJTopicCarkChoiceAnswerItemCell *lastCell = (YJTopicCarkChoiceAnswerItemCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.choiceIndex inSection:0]];
    lastCell.isSelected = NO;
    YJTopicCarkChoiceAnswerItemCell *cell = (YJTopicCarkChoiceAnswerItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = YES;
    if (self.answerResultBlock) {
        self.answerResultBlock([NSString stringWithFormat:@"%c",(int)indexPath.row+65]);
    }
    self.choiceIndex = indexPath.row;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        CGFloat w = (LG_ScreenWidth-70)/4;
        layout.itemSize = CGSizeMake(w, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[YJTopicCarkChoiceAnswerItemCell class] forCellWithReuseIdentifier:NSStringFromClass([YJTopicCarkChoiceAnswerItemCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
- (UILabel *)indexLab{
    if (!_indexLab) {
        _indexLab = [UILabel new];
//        _indexLab.textAlignment = NSTextAlignmentCenter;
        _indexLab.font = LG_SysFont(16);
        _indexLab.textColor = [UIColor darkGrayColor];
    }
    return _indexLab;
}
@end
