//
//  YJAnaDetailChoiceCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/9/25.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "YJAnaDetailChoiceCell.h"
#import "YJBasePaperModel.h"
#import "YJAnaDetailChoiceCollectionCell.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"

static CGFloat YJAnaDetailChoiceCollectionCellHeight = 80;
@interface YJAnaDetailChoiceCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *analysisL;
@end
@implementation YJAnaDetailChoiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(YJAnaDetailChoiceCollectionCellHeight);
        }];
        
        [self.contentView addSubview:self.analysisL];
        [self.analysisL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJAnaDetailChoiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJAnaDetailChoiceCollectionCell class]) forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
        {
            cell.titleStr = @"本题得分";
            if (!IsStrEmpty(self.smallModel.yj_smallAnswerScore) && self.smallModel.yj_smallAnswerScore.floatValue >= 0) {
                cell.content = self.smallModel.yj_smallAnswerScore;
                cell.contentColor = LG_ColorWithHex(0x2eb3f1);
            }else{
                 cell.content = @"--";
                cell.contentColor = LG_ColorWithHex(0xa7a7a7);
            }
        }
            break;
        case 1:
        {
            NSInteger UserType = [NSUserDefaults yj_integerForKey:YJTaskModule_UserType_UserDefault_Key];
            if (UserType == 1) {
                cell.titleStr = @"学生答案";
            }else{
                cell.titleStr = @"我的答案";
            }
            if (!IsStrEmpty(self.smallModel.yj_smallAnswer)) {
                if (self.isSubmit) {
                    if (self.smallModel.yj_smallAnswerScore.floatValue >= self.smallModel.yj_smallScore.floatValue*0.6) {
                        cell.contentColor = LG_ColorWithHex(0x03bd3c);
                    }else{
                        cell.contentColor = LG_ColorWithHex(0xff4200);
                    }
                }else{
                    cell.contentColor = LG_ColorWithHex(0x333333);
                }
                cell.content = self.smallModel.yj_smallAnswer;
            }else{
                cell.content = @"未作答";
                cell.contentColor = LG_ColorWithHex(0xff4200);
            }
        }
            break;
        case 2:
        {
            cell.titleStr = @"参考答案";
            if (!IsStrEmpty(self.smallModel.yj_smallStandardAnswer)) {
                cell.content = [self.smallModel.yj_smallStandardAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }else{
                cell.content = @"--";
            }
            cell.contentColor = LG_ColorWithHex(0x03BD3C);
        }
            break;

    }
    return cell;
}




- (void)setSmallModel:(YJBasePaperSmallModel *)smallModel{
    _smallModel = smallModel;
    if (!IsStrEmpty(smallModel.yj_smallAnswerAnalysis)) {
        self.analysisL.text = [NSString stringWithFormat:@"本题解析: %@",smallModel.yj_smallAnswerAnalysis];
    }
     [self.collectionView reloadData];
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        CGFloat itemW = (LG_ScreenWidth - 2)/3;
        layout.itemSize = CGSizeMake(itemW, YJAnaDetailChoiceCollectionCellHeight-2);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
        _collectionView.backgroundColor = LG_ColorWithHex(0xf2f2f2);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.userInteractionEnabled = NO;
        [_collectionView registerClass:[YJAnaDetailChoiceCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([YJAnaDetailChoiceCollectionCell class])];
    }
    return _collectionView;
}
- (UILabel *)analysisL{
    if (!_analysisL) {
        _analysisL = [UILabel new];
        _analysisL.font = [UIFont systemFontOfSize:17];
        _analysisL.textColor = LG_ColorWithHex(0x333333);
        _analysisL.numberOfLines = 0;
    }
    return _analysisL;
}
@end
