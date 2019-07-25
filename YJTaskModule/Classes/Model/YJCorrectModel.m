//
//  YJCorrectModel.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/22.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJCorrectModel.h"
#import "YJConst.h"

@implementation YJCorrectAnswerInfoModel

@end

@implementation YJCorrectTextInfoModel
- (void)setText:(NSString *)Text{
    if (!IsStrEmpty(Text) && [Text containsString:@"&#"]) {
        NSAttributedString *attr = Text.yj_toHtmlMutableAttributedString;
        _Text = attr.string;
    }else{
        _Text = Text;
    }
}
@end

@implementation YJCorrectAnswerAreaModel

@end

@implementation YJCorrectGenreInfoModel

@end

@implementation YJCorrectModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"ModelAnswerInfoList":[YJCorrectAnswerInfoModel class],
             @"ModelTextInfoList":[YJCorrectTextInfoModel class],
             @"ModelAnswerAreaList":[YJCorrectAnswerAreaModel class]
             };
}
- (void)setQuesLeaderContent:(NSString *)QuesLeaderContent{
    _QuesLeaderContent = QuesLeaderContent;
    if (!IsStrEmpty(QuesLeaderContent)) {
        _QuesLeaderContent = QuesLeaderContent.yj_toHtmlMutableAttributedString.string;
    }
}

- (NSDictionary *)QuesAnswerInfo{
    if (!_QuesAnswerInfo) {
        return @{};
    }
    return _QuesAnswerInfo;
}
@end
