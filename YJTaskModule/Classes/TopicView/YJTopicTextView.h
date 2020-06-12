//
//  YJTopicTextView.h
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YJTextAttachment: NSTextAttachment
@property (nonatomic,assign) NSInteger textIndex;
@end

@interface YJTopicTextView : UITextView
@property (nonatomic,assign) NSInteger currentSmallIndex;
@property (nonatomic,strong) NSArray<NSString *> *answerResults;
@property (nonatomic,strong) NSArray<NSString *> *topicIndexs;
@property (nonatomic,copy) NSString *topicPintro;
@property (nonatomic,copy) NSString *topicContent;
- (void)setBlankAttributedString:(NSAttributedString *)blankAttributedString;
- (void)setTopicContentAttr:(NSAttributedString *) topicContentAttr;
- (NSInteger)totalBlankCount;
@end
