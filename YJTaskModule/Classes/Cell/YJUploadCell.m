//
//  YJUploadCell.m
//  LGEducationCloud
//
//  Created by 刘亚军 on 2017/8/28.
//  Copyright © 2017年 lange. All rights reserved.
//

#import "YJUploadCell.h"
#import "YJTalkImageDeleteView.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"
#import <SDWebImage/UIImageView+WebCache.h>
#pragma mark -

@interface YJMoreCell ()
@property (nonatomic,strong)UIImageView *imageView;
@end
@implementation YJMoreCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
    }
    return self;
}
- (void)configure{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)initUI{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage yj_imageNamed:@"add_photo" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
    }
    return _imageView;
}
@end

#pragma mark -

@interface YJUploadCell ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) YJTalkImageDeleteView *deleteView;
@property (nonatomic, assign) CGPoint oriCenter;
@end
@implementation YJUploadCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configure];
        [self initUI];
    }
    return self;
}
- (void)configure{
//    self.backgroundColor = [UIColor whiteColor];
//    [self J1_clipLayerWithRadius:0 width:1 color:[UIColor lightGrayColor]];
}
- (void)initUI{
    self.imageView.hidden = NO;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.bounds = self.contentView.bounds;
    self.imageView.center = self.contentView.center;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    [self.imageView yj_clipLayerWithRadius:0 width:1 color:LG_ColorWithHex(0xe5e5e5)];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    longGes.delegate = self;
    longGes.minimumPressDuration = 0.3;
    [self.imageView addGestureRecognizer:longGes];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)longGes:(UILongPressGestureRecognizer *)longGes{
    if (longGes.state == UIGestureRecognizerStateBegan) {
        self.deleteView = [YJTalkImageDeleteView showTalkImageDeleteViewAtBottom:self.isBottom];
    }else if (longGes.state == UIGestureRecognizerStateEnded){
        [self.deleteView hide];
    }
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    //坐标转换
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    CGPoint transP = [pan translationInView:self];
    UIView *tagButton = pan.view;
    
    // 开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.oriCenter = tagButton.center;
        [UIView animateWithDuration:-.25 animations:^{
            tagButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        
        if (!self.deleteView || !self.deleteView.superview) {
            self.deleteView = [YJTalkImageDeleteView showTalkImageDeleteViewAtBottom:self.isBottom];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:tagButton];
        
        tagButton.top = rect.origin.y + tagButton.top;
        tagButton.left = rect.origin.x + tagButton.left;
    }
    CGPoint center = tagButton.center;
    center.x += transP.x;
    center.y += transP.y;
    tagButton.center = center;
    
    // 改变
    BOOL isDelete = NO;
    if (self.isBottom) {
        if ((tagButton.y + tagButton.height)  > (LG_ScreenHeight - self.deleteView.height)) {
            isDelete = YES;
        }
    }else{
        if (tagButton.y < self.deleteView.height) {
            isDelete = YES;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (isDelete) {
            [self.deleteView setDeleteViewDeleteState];
        }else {
            [self.deleteView setDeleteViewNormalState];
        }
        
    }
    
    // 结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (isDelete) {
            [tagButton removeFromSuperview];
            if (self.deleteBlock) {
                self.deleteBlock();
            }
        }
        [self.deleteView hide];
        
        [UIView animateWithDuration:0.25 animations:^{
            tagButton.transform = CGAffineTransformIdentity;
            tagButton.center = self.oriCenter;
            tagButton.left = tagButton.left + rect.origin.x;
            tagButton.top = tagButton.top + rect.origin.y;
        } completion:^(BOOL finished) {
            tagButton.center = self.contentView.center;
            [self.contentView addSubview:tagButton];
        }];
        
    }
    
    [pan setTranslation:CGPointZero inView:self];
}
- (void)setTaskImage:(UIImage *)taskImage{
    self.imageView.hidden = NO;
    self.imageView.image = taskImage;
}
- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    self.imageView.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage yj_imageWithColor:LG_ColorWithHex(0x999999) size:CGSizeMake(LG_ScreenWidth, LG_ScreenHeight)]];
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
