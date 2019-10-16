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
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < self.paperModel.yj_bigTopicList.count; i++) {
        YJBasePaperBigModel *bigModel = (YJBasePaperBigModel *)self.paperModel.yj_bigTopicList[i];
        NSMutableArray *answers = [NSMutableArray array];
        NSMutableArray *indexs = [NSMutableArray array];
        for (YJBasePaperSmallModel *smallModel in bigModel.yj_smallTopicList) {
            if (!IsStrEmpty(smallModel.yj_smallAnswer) ||(smallModel.yj_smallTopicType == YJSmallTopicTypeWritting && !IsArrEmpty(smallModel.yj_imgUrlArr))) {
                NSString *separateStr = [NSString stringWithFormat:@"%c",1];
                NSString *answerStr = smallModel.yj_smallAnswer;
                if (smallModel.yj_smallItemCount > 1 &&
                    [[answerStr componentsSeparatedByString:separateStr] containsObject:@""]) {
                    [answers addObject:@(0)];
                }else{
                    [answers addObject:@(1)];
                }
            }else{
                [answers addObject:@(0)];
            }
            [indexs addObject:@(smallModel.yj_smallPaperIndex)];
        }
        YJTaskCarkModel *model = [[YJTaskCarkModel alloc] init];
        model.topcTypeName = bigModel.yj_bigTopicTypeName;
        model.answerResults = answers;
        model.indexs = indexs;
        model.topicIndex = bigModel.yj_bigIndex;
        [dataArr addObject:model];
    }
    return dataArr;
}
@end
