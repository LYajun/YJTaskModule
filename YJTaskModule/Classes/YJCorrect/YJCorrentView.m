//
//  YJCorrentView.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJCorrentView.h"
#import "YJCorrectModel.h"
#import "YJCorrectCell.h"
#import "YJCorrectFlowLayout.h"
#import "YJCorrectAnswerView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import "YJPaperModel.h"
#define kAnswerViewWidth 300
@interface YJCorrentAnswerItem : UILabel
@property (nonatomic,copy) NSString *tagStr;
@property (nonatomic,copy) void (^tapBlock) (NSString *tagStr);
@end
@implementation YJCorrentAnswerItem
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.tapBlock) {
        self.tapBlock(self.tagStr);
    }
}
- (NSInteger)tagIndex{
    NSArray *tagArr = [self.tagStr componentsSeparatedByString:@"_"];
    return [tagArr.lastObject integerValue];
}
@end

@interface YJCorrentView ()<YJCorrectFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YJCorrectAnswerViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) YJCorrectCell *currentCell;

@property (nonatomic,assign) BOOL isAnswering;
@property (nonatomic,assign) YJCorrectAnswerType currentAnswerType;



@end

@implementation YJCorrentView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.top.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHideMenuNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
           [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect absoluteRect = [self convertRect:self.currentCell.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat offset = LG_ScreenHeight - (absoluteRect.origin.y + absoluteRect.size.height);
    if (offset >= 0 && offset < keyboardHeight) {
        self.transform = CGAffineTransformMakeTranslation(0, -(keyboardHeight-offset));
        YJCorrectAnswerView *answerView = nil;
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:YJCorrectAnswerView.class]) {
                answerView = (YJCorrectAnswerView *)view;
                break;
            }
        }
        if (answerView) {
            answerView.y -= (keyboardHeight-offset);
        }
    }
}
- (void)keyboardWillHide: (NSNotification *)notification{
    self.transform = CGAffineTransformIdentity;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCorrentModel:(YJCorrectModel *)correntModel{
    _correntModel = correntModel;
    
    [self.collectionView reloadData];
    
}

#pragma mark - YJCorrectAnswerViewDelegate

- (void)YJCorrectAnswerView:(YJCorrectAnswerView *)answerView didFinishAnswer:(nonnull NSString *)answerStr{
    self.isAnswering = NO;
    if (IsStrEmpty(answerStr) || IsStrEmpty([answerStr yj_deleteWhitespaceCharacter])) {
        self.currentCell.answerType = YJCorrectAnswerTypeNo;
        [self menuControllerWillHideMenuNotification:nil];
    }else{
        self.currentCell.answerType = self.currentAnswerType;
        
        [self updateAnswer:answerStr atCell:self.currentCell atAnswerType:self.currentAnswerType];
        
    }
    
    [self menuControllerWillHideMenuNotification:nil];
}
- (void)updateAnswer:(NSString *)answerStr atCell:(YJCorrectCell *)correctCell atAnswerType:(YJCorrectAnswerType)answerType{
    YJCorrentAnswerItem *answerItem = [[YJCorrentAnswerItem alloc] initWithFrame:CGRectMake(0, 0, [answerStr yj_widthWithFont:[UIFont systemFontOfSize:16]], 26)];
    answerItem.userInteractionEnabled = self.editable;
    answerItem.tagStr = [NSString stringWithFormat:@"A_%li",correctCell.currentIndex];
    answerItem.textAlignment = NSTextAlignmentCenter;
    answerItem.font = [UIFont systemFontOfSize:16];
    answerItem.textColor = LG_ColorWithHex(0xFF0000);
    answerItem.text = answerStr;
    answerItem.centerY = correctCell.centerY - correctCell.height/2 - answerItem.height/2-4;
    
    __weak typeof(self) weakSelf = self;
    answerItem.tapBlock = ^(NSString *tagStr) {
        NSInteger index = [[tagStr componentsSeparatedByString:@"_"].lastObject integerValue];
        YJCorrectCell *cell = (YJCorrectCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell removeAnswerLab];
    };
    
    YJCorrentAnswerItem *answerFlagItem = [[YJCorrentAnswerItem alloc] initWithFrame:CGRectMake(0, 0, 10, 14)];
    answerFlagItem.tagStr = [NSString stringWithFormat:@"F_%li",correctCell.currentIndex];
    answerFlagItem.textAlignment = NSTextAlignmentCenter;
    answerFlagItem.font = [UIFont systemFontOfSize:15];
    answerFlagItem.textColor = LG_ColorWithHex(0xFF0000);
    answerFlagItem.text = @"∨";
    answerFlagItem.centerY = correctCell.centerY - 8;
    
    CGFloat superViewWidth = LG_ScreenWidth-40;
    
    switch (answerType) {
        case YJCorrectAnswerTypeModify:
        {
            CGFloat offsetLeft = correctCell.centerX - answerItem.width/2;
            CGFloat offsetRight = correctCell.centerX + answerItem.width/2;
            if (offsetLeft < 0) {
                answerItem.x = 0;
                answerItem.textAlignment = NSTextAlignmentLeft;
                
            }else if (offsetRight > superViewWidth){
                answerItem.x = superViewWidth - answerItem.width;
                answerItem.textAlignment = NSTextAlignmentRight;
            }else{
                answerItem.centerX = correctCell.centerX;
            }
            
            [self updateAnswerInfoWithAnswerStr:answerStr atCell:correctCell atAnswerType:answerType];
            
        }
            break;
        case YJCorrectAnswerTypePreAdd:
        {
            
            CGFloat offsetLeft = correctCell.x - answerItem.width/2;
            CGFloat offsetRight = correctCell.x + answerItem.width/2;
            if (offsetLeft < 0) {
                answerItem.textAlignment = NSTextAlignmentLeft;
                answerItem.x = -3;
            }else if (offsetRight > superViewWidth){
                answerItem.textAlignment = NSTextAlignmentRight;
                answerItem.x = superViewWidth - answerItem.width;
            }else{
                answerItem.centerX = correctCell.x-1;
            }
            if (correctCell.x <= 2) {
                answerFlagItem.x = -2;
            }else{
                answerFlagItem.centerX = correctCell.x-1;
            }
            [self.collectionView addSubview:answerFlagItem];
            
            [self updateAnswerInfoWithAnswerStr:answerStr atCell:correctCell atAnswerType:answerType];
        }
            
            break;
        default:
            break;
    }
    if (answerItem.x < 0) {
        answerItem.x = 0;
        answerItem.width = superViewWidth;
    }
    [self.collectionView addSubview:answerItem];
}
- (void)updateAnswerInfoWithAnswerStr:(NSString *)answerStr atCell:(YJCorrectCell *)correctCell atAnswerType:(YJCorrectAnswerType)answerType{
    
    NSString *endText = @"";
    if (correctCell.currentIndex == self.correntModel.ModelTextInfoList.count-1) {
        endText = @"结束";
    }else{
        YJCorrectTextInfoModel *textInfoModel = self.correntModel.ModelTextInfoList[correctCell.currentIndex+1];
        endText = textInfoModel.Text;
       
        if (!IsStrEmpty(textInfoModel.Text) && textInfoModel.Text.length == 1 && ![self predicateMatchWithText:textInfoModel.Text matchFormat:@"^[A-Za-z]+$"] && ![self predicateMatchWithText:textInfoModel.Text matchFormat:@"^[\u4e00-\u9fa5]{0,}$"]) {
            if (correctCell.currentIndex == self.correntModel.ModelTextInfoList.count-2) {
                endText = [NSString stringWithFormat:@"%@结束",endText];
            }else{
                YJCorrectTextInfoModel *eTextTextInfoModel = self.correntModel.ModelTextInfoList[correctCell.currentIndex+2];
                endText = [NSString stringWithFormat:@"%@%@",endText,eTextTextInfoModel.Text];
            }
        }
    }
    
    NSMutableDictionary *dic = self.correntModel.QuesAnswerInfo.mutableCopy;
    NSString *startText = @"";
    if (correctCell.currentIndex == 0) {
        startText = @"开始";
    }else{
        YJCorrectTextInfoModel *preTextInfoModel = self.correntModel.ModelTextInfoList[correctCell.currentIndex-1];
        startText = preTextInfoModel.Text;
        if (!IsStrEmpty(preTextInfoModel.Text) && preTextInfoModel.Text.length == 1 && ![self predicateMatchWithText:preTextInfoModel.Text matchFormat:@"^[A-Za-z]+$"] && ![self predicateMatchWithText:preTextInfoModel.Text matchFormat:@"^[\u4e00-\u9fa5]{0,}$"]) {
            if (correctCell.currentIndex == 1) {
                startText = [NSString stringWithFormat:@"开始%@",startText];
            }else{
                YJCorrectTextInfoModel *pPreTextInfoModel = self.correntModel.ModelTextInfoList[correctCell.currentIndex-2];
                startText = [NSString stringWithFormat:@"%@%@",pPreTextInfoModel.Text,startText];
            }
        }
        
    }
    NSString *type = @"0";
    NSString *answer = @"";
    NSString *result = @"";
    if (answerType == YJCorrectAnswerTypeDelete) {
        type = @"0";
        answer = @"";
       result = [NSString stringWithFormat:@"(%@)%@(%@)→删除%@",startText,correctCell.text,endText,correctCell.text];
    }else if (answerType == YJCorrectAnswerTypeModify){
        type = @"1";
        answer = answerStr;
        result = [NSString stringWithFormat:@"(%@)%@(%@)→%@",startText,correctCell.text,endText,answer];
    }else if (answerType == YJCorrectAnswerTypePreAdd){
        type = @"2";
        answer = answerStr;
        result = [NSString stringWithFormat:@"(%@)∧(%@)→%@",startText,correctCell.text,answer];
    }
    NSDictionary *answerInfo = @{
                                 @"type":type,
                                 @"start":startText,
                                 @"text":correctCell.text,
                                 @"answer":answer,
                                 @"end":endText,
                                 @"result":result
                                 };
    [dic setObject:answerInfo forKey:[NSString stringWithFormat:@"%li",correctCell.currentIndex]];
    
    self.correntModel.QuesAnswerInfo = dic;
    
    [self.bigModel configCorrectAnswerInfo:self.correntModel.QuesAnswerInfo];
    
     [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
}
- (BOOL)predicateMatchWithText:(NSString *) text matchFormat:(NSString *) matchFormat{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject:text];
}
#pragma mark - UIMenuController通知
- (void)menuControllerWillHideMenuNotification:(NSNotification *)noti{
    if (self.currentCell && self.currentCell.isSelect && !self.isAnswering) {
        self.currentCell.isSelect = NO;
    }
}

#pragma mark - collectionView协议方法
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
    [self menuControllerWillHideMenuNotification:nil];
    
    self.currentCell = (YJCorrectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.currentCell.isSelect = YES;
    self.currentAnswerType = YJCorrectAnswerTypeNo;
    
    if([NSStringFromSelector(action) isEqualToString:@"removeItem:"]){
        if (!IsArrEmpty(self.correntModel.QuesAnswerInfo) && self.correntModel.QuesAnswerInfo.count >= self.bigModel.yj_smallTopicList.count) {
            [LGAlert showInfoWithStatus:[NSString stringWithFormat:@"此题只有%li处问题",self.bigModel.yj_smallTopicList.count]];
            return;
        }
        
        
        NSLog(@"remove action");
        self.currentAnswerType = YJCorrectAnswerTypeDelete;
        self.currentCell.answerType = YJCorrectAnswerTypeDelete;
        
        [self updateAnswerInfoWithAnswerStr:@"" atCell:self.currentCell atAnswerType:YJCorrectAnswerTypeDelete];
        
        
    }else if ([NSStringFromSelector(action) isEqualToString:@"correctLabTap"]){
    }else if ([NSStringFromSelector(action) isEqualToString:@"removeAnswerItem:"]){
        self.currentCell.answerType = YJCorrectAnswerTypeNo;
        
        NSString *aTagstr = [NSString stringWithFormat:@"A_%li",self.currentCell.currentIndex];
        NSString *fTagstr = [NSString stringWithFormat:@"F_%li",self.currentCell.currentIndex];
        for (UIView *view in self.collectionView.subviews) {
            if ([view isKindOfClass:YJCorrentAnswerItem.class] && ([[(YJCorrentAnswerItem *)view tagStr] isEqualToString:aTagstr] || [[(YJCorrentAnswerItem *)view tagStr] isEqualToString:fTagstr])) {
                [view removeFromSuperview];
            }
        }
        NSMutableDictionary *dic = self.correntModel.QuesAnswerInfo.mutableCopy;
        if ([dic.allKeys containsObject:[NSString stringWithFormat:@"%li",self.currentCell.currentIndex]]) {
            [dic removeObjectForKey:[NSString stringWithFormat:@"%li",self.currentCell.currentIndex]];
        }
        self.correntModel.QuesAnswerInfo = dic;
        [self.bigModel configCorrectAnswerInfo:self.correntModel.QuesAnswerInfo];
        
    }else if ([NSStringFromSelector(action) isEqualToString:@"correctItem:"]){
        if (!IsArrEmpty(self.correntModel.QuesAnswerInfo) && self.correntModel.QuesAnswerInfo.count >= self.bigModel.yj_smallTopicList.count) {
            [LGAlert showInfoWithStatus:[NSString stringWithFormat:@"此题只有%li处问题",self.bigModel.yj_smallTopicList.count]];
            return;
        }
        
         self.currentAnswerType = YJCorrectAnswerTypeModify;
       YJCorrectAnswerView *answerView = [[YJCorrectAnswerView alloc] initWithAnswerWidth:kAnswerViewWidth placehold:[NSString stringWithFormat:@"将%@改为",self.currentCell.text] delegate:self];
        
        [answerView showRelyOnView:self.currentCell];
        
        
        self.isAnswering = YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"preAddItem:"]){
        if (!IsArrEmpty(self.correntModel.QuesAnswerInfo) && self.correntModel.QuesAnswerInfo.count >= self.bigModel.yj_smallTopicList.count) {
            [LGAlert showInfoWithStatus:[NSString stringWithFormat:@"此题只有%li处问题",self.bigModel.yj_smallTopicList.count]];
            return;
        }
        
         self.currentAnswerType = YJCorrectAnswerTypePreAdd;
        YJCorrectAnswerView *answerView = [[YJCorrectAnswerView alloc] initWithAnswerWidth:kAnswerViewWidth placehold:[NSString stringWithFormat:@"在%@之前增加",self.currentCell.text] delegate:self];
       
        [answerView showRelyOnView:self.currentCell];
        
        self.isAnswering = YES;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.correntModel.ModelTextInfoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJCorrectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJCorrectCell class]) forIndexPath:indexPath];
    YJCorrectTextInfoModel *textInfo = self.correntModel.ModelTextInfoList[indexPath.row];
    cell.currentIndex = indexPath.row;
    cell.text = textInfo.Text;
    cell.userInteractionEnabled = self.editable;
    
    if (!IsArrEmpty(self.correntModel.QuesAnswerInfo) && [self.correntModel.QuesAnswerInfo.allKeys containsObject:[NSString stringWithFormat:@"%li",indexPath.row]]) {
        
        NSLog(@"%li ----  %@",indexPath.row,self.correntModel.QuesAnswerInfo.allKeys);
        
        NSDictionary *dic = [self.correntModel.QuesAnswerInfo objectForKey:[NSString stringWithFormat:@"%li",indexPath.row]];
        NSString *type = [dic objectForKey:@"type"];
        NSString *answer = [dic objectForKey:@"answer"];
        switch (type.integerValue) {
            case 0:
                cell.answerType = YJCorrectAnswerTypeDelete;
                break;
            case 1:
                cell.answerType = YJCorrectAnswerTypeModify;
                [self updateAnswer:answer atCell:cell atAnswerType:YJCorrectAnswerTypeModify];
                break;
            case 2:
                cell.answerType = YJCorrectAnswerTypePreAdd;
                [self updateAnswer:answer atCell:cell atAnswerType:YJCorrectAnswerTypePreAdd];
                break;
            default:
                break;
        }
    }else{
       cell.answerType = YJCorrectAnswerTypeNo;
    }
    
    return cell;
}


#pragma mark - YJCorrectFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YJCorrectFlowLayout *)collectionViewLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath{
    YJCorrectTextInfoModel *textInfo = self.correntModel.ModelTextInfoList[indexPath.row];
    CGSize stringSize = [textInfo.Text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    return stringSize.width+4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(YJCorrectFlowLayout *)collectionViewLayout heightForHeaderAtIndexPath:(NSIndexPath *)indexPath{
    return 2;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        YJCorrectFlowLayout *layout = [[YJCorrectFlowLayout alloc] init];
        layout.topInset = 1;
        layout.delegate = self;
        layout.leftMargin = 10 + 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[YJCorrectCell class] forCellWithReuseIdentifier:NSStringFromClass([YJCorrectCell class])];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
@end
