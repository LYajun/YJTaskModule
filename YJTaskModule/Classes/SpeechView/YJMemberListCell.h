
//
//  YJMemberListCell.h
//  YJTaskModule_Example
//
//  Created by 刘亚军 on 2020/7/17.
//  Copyright © 2020 lyj. All rights reserved.
//

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJMemberListCell : LGBaseTableViewCell
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL choice;
@end



@interface YJTaskSearchBar : UITextField
@property (nonatomic, copy) void(^removeBlock)(void);
@end
NS_ASSUME_NONNULL_END
