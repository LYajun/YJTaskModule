//
//  YJTaskCardItem.h
//
//
//  Created by 刘亚军 on 2018/8/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJTaskCardItem : UICollectionViewCell
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isFinishAnswer;
@property (nonatomic,assign) BOOL isCurrentTopic;
@property (nonatomic,assign) BOOL isManualMarkMode;
@end
