//
//  YJTaskChoiceLabel.m
//  YJTaskKit
//
//  Created by 刘亚军 on 2018/7/27.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJTaskChoiceLabel.h"
#import "YJConst.h"

@interface YJTaskChoiceLabel ()

@end

@implementation YJTaskChoiceLabel
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}
- (void)configure{
    [self yj_clipLayerWithRadius:LabHeight/2 width:0 color:nil];
    self.textColor = LG_ColorWithHex(0x252525);
    self.bgImageName = @"lg_choice_n";
}
- (void)setIsChoiced:(BOOL)isChoiced{
    _isChoiced = isChoiced;
    if (isChoiced) {
        self.textColor = [UIColor whiteColor];
        self.bgImageName = @"lg_choice_s";
    }else{
        self.textColor = LG_ColorWithHex(0x252525);
        self.bgImageName = @"lg_choice_n";
    }
}
- (void)setIsRight:(BOOL)isRight{
    _isRight = isRight;
    self.textStr = @"";
    if (isRight) {
        self.bgImageName = @"lg_choice_r";
    }else{
        self.bgImageName = @"lg_choice_w";
    }
}
- (void)setIndex:(NSInteger)index{
    _index = index;
    self.textStr = [NSString stringWithFormat:@"%c",(int)self.index+65];
}
@end
