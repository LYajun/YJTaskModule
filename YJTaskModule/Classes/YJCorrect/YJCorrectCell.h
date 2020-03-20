//
//  YJCorrectCell.h
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YJCorrectAnswerType){
    YJCorrectAnswerTypeNo,
    YJCorrectAnswerTypeDelete,
    YJCorrectAnswerTypeModify,
    YJCorrectAnswerTypePreAdd
};

@interface YJCorrectCell : UICollectionViewCell
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) YJCorrectAnswerType answerType;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger currentIndex;

- (void)removeAnswerLab;
@end

NS_ASSUME_NONNULL_END
