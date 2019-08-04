//
//  YJScoreAlert.h
//  AFNetworking
//
//  Created by 刘亚军 on 2019/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJScoreAlert : UIView
/** 总分 */
@property (nonatomic,assign) float totalScore;
/** 得分 */
@property (nonatomic,assign) float answerScore;

/** 正确题数 */
@property (nonatomic,assign) NSInteger rightCount;
/** 错误题数 */
@property (nonatomic,assign) NSInteger wrongCount;

/** 大题数 */
@property (nonatomic,assign) NSInteger bigTopicCount;
/** 小题数 */
@property (nonatomic,assign) NSInteger smallTopicCount;

/** 隐藏回调 */
@property (nonatomic,copy) void (^hideBlock) (void);

+ (YJScoreAlert *)scoreAlertWithSize:(CGSize)size;

- (void)show;
@end

NS_ASSUME_NONNULL_END
