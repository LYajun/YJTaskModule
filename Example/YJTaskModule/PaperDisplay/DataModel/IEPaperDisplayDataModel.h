//
//  IEPaperDisplayDataModel.h
//  LGIntellectExam
//
//  Created by dangwc on 2019/7/11.
//  Copyright © 2019 dangwc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YJPaperModel,YJTaskCarkModel;
@interface IEPaperDisplayDataModel : NSObject
@property (nonatomic,copy) NSString *resOriginTypeID;
@property (nonatomic,weak) UIViewController *ownController;
- (void)loadPaperData;
- (YJPaperModel *)paperModel;
- (NSArray<YJTaskCarkModel *> *)taskCarkModelArray;
@end

NS_ASSUME_NONNULL_END
