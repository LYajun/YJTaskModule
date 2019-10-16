//
//  YJTaskTopicCell.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@interface YJTaskTopicCell : LGBaseTableViewCell
@property (nonatomic,copy) NSString *topicText;
@property (nonatomic,copy) NSString *voiceUrl;
@property (nonatomic,strong) NSMutableAttributedString *textAttr;
@property (nonatomic,copy) void (^playBlock) (void);
- (void)invalidatePlayer;
@end
