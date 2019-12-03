//
//  IEPaperDisplayDataModel.m
//  LGIntellectExam
//
//  Created by dangwc on 2019/7/11.
//  Copyright © 2019 dangwc. All rights reserved.
//

#import "IEPaperDisplayDataModel.h"
#import <YJTaskModule/YJPaperModel.h>
#import <YJTaskModule/YJTaskCarkModel.h>
#import "IEPaperDisplayProtocol.h"
#import <MJExtension/MJExtension.h>
#import <YJTaskModule/YJConst.h>
@interface IEPaperDisplayDataModel ()
@property (nonatomic,strong) YJPaperModel *paperModel;
@end
@implementation IEPaperDisplayDataModel
- (void)loadPaperData{
    //测试数据
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"task_writting" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *jsonString = [data mj_JSONString];
    //防止界面卡顿
//    dispatch_async(dispatch_get_main_queue(), ^{
    self.paperModel =  [YJPaperModel mj_objectWithKeyValues:jsonString];
    self.paperModel.ResOriginTypeID = 20;
         [(id<IEPaperDisplayProtocol>)self.ownController loadPaperDataSuccess];
//    });
}

- (NSArray<YJTaskCarkModel *> *)taskCarkModelArray{
    return self.paperModel.taskCarkModelArray;
}
@end
