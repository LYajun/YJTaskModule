//
//  YJCorrectLab.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2019/4/23.
//  Copyright © 2019 lange. All rights reserved.
//

#import "YJCorrectLab.h"

@interface YJCorrectLab ()

@end
@implementation YJCorrectLab
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (self.isAnswer) {
        if (action == @selector(removeAnswer:)){
            return YES;
        }
    }else{
        if (action == @selector(remove:) ||
            action == @selector(correct:) ||
            action == @selector(preAdd:)) {
            return YES;
        }
    }
    return NO;
}
- (void)removeAnswerLab{
    [self tapAction:nil];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.tapBlock) {
        self.tapBlock();
    }
    [self createMenu];
}
- (void)createMenu{
    [self becomeFirstResponder];
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    
    UIMenuItem *removeItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(remove:)];
    
    UIMenuItem *removeAnswerItem = [[UIMenuItem alloc] initWithTitle:@"删除此答案" action:@selector(removeAnswer:)];
    
    UIMenuItem *correntItem = [[UIMenuItem alloc] initWithTitle:@"改" action:@selector(correct:)];
    
    UIMenuItem *preAddItem = [[UIMenuItem alloc] initWithTitle:@"在之前添加" action:@selector(preAdd:)];
    
    [popMenu setMenuItems:@[removeItem,correntItem,preAddItem,removeAnswerItem]];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    [popMenu setTargetRect:self.frame inView:self.superview];
    [popMenu setMenuVisible:YES animated:YES];
    
}
#pragma mark - Action
- (void)remove:(UIMenuController *)menu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(remove:)]) {
        [self.delegate remove:self];
    }
}
- (void)removeAnswer:(UIMenuController *)menu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeAnswer:)]) {
        [self.delegate removeAnswer:self];
    }
}
- (void)correct:(UIMenuController *)menu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(correct:)]) {
        [self.delegate correct:self];
    }
}
- (void)preAdd:(UIMenuController *)menu{
    if (self.delegate && [self.delegate respondsToSelector:@selector(preAdd:)]) {
        [self.delegate preAdd:self];
    }
}

@end
