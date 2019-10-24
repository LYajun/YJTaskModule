//
//  YJWebViewController.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/3/25.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJWebViewController.h"
#import <AFNetworking/AFNetworking.h>

#import "TFHpple.h"
#import  <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <YJSearchController/YJChineseInclude.h>
#import "YJConst.h"
#import "LGActivityIndicatorView.h"
#import <WebKit/WebKit.h>

@interface YJWebViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
/** 加载中 */
@property (strong, nonatomic) UIView *viewLoading;
/** 没有数据 */
@property (strong, nonatomic) UIView *viewNoData;
@property (strong, nonatomic) UILabel *labNoData;
/** 发生错误 */
@property (strong, nonatomic) UIView *viewLoadError;
@property (strong, nonatomic) UILabel *labLoadError;
/** 已加载成功 */
@property (nonatomic,assign) BOOL isLoadPdfSuccess;
@end

@implementation YJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.ResFileExtension.lowercaseString containsString:@"html"] && ![self.ResFileExtension.lowercaseString containsString:@"pdf"]) {
        [self setTextNoData:@"当前不支持查看此格式的资料哦!"];
        [self setViewNoDataShow:YES];
    }else{
        [self layoutUI];
        [self downloadOnlineFile];
    }
}
- (void)layoutUI{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerY.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).mas_offset(10);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AVAudioSession *s = [AVAudioSession sharedInstance];
    if ([self.ResFileExtension.lowercaseString containsString:@"html"] &&  s) {
        [s setActive:YES error:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AVAudioSession *s = [AVAudioSession sharedInstance];
    if ([self.ResFileExtension.lowercaseString containsString:@"html"] && s) {
        [s setActive:NO error:nil];
    }
    if (self.isLoadPdfSuccess) {
        [self downloadOnlineFile];
    }
}

- (NSString *)filePath{
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/YJ_File/",NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

- (void)loadErrorUpdate{

    [self downloadOnlineFile];
}

- (NSString *)modifyImgSrc:(NSString *)htmlStr{
    __block NSString *html = htmlStr.copy;
    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    // 解析html数据
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    // 根据标签来进行过滤
    NSArray *imgArray = [xpathParser searchWithXPathQuery:@"//img"];
    if (!IsArrEmpty(imgArray)) {
        [imgArray enumerateObjectsUsingBlock:^(TFHppleElement *hppleElement, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *attributes = hppleElement.attributes;
            NSString *src = [attributes objectForKey:@"src"];
            if ([src containsString:@"/"]) {
                NSString *name = [src componentsSeparatedByString:@"/"].lastObject;
                html = [html stringByReplacingOccurrencesOfString:src withString:name];
            }
        }];
    }
    return html;
}
- (void)loadFileWithUrl:(NSString *)url{
    if (![self.ResFileExtension.lowercaseString containsString:@"html"] && ![self.ResFileExtension.lowercaseString containsString:@"pdf"]) {
        [self setTextNoData:@"当前不支持查看此格式的资料哦!"];
        [self setViewNoDataShow:YES];
    }else{
        self.fileUrl = url;
        [self downloadOnlineFile];
    }
    
}

-(void)downloadOnlineFile{
    NSString* urlString = self.fileUrl;
    if ([YJChineseInclude isIncludeChineseInString:urlString]) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if ([self.ResFileExtension.lowercaseString containsString:@"html"]) {
        [self setViewLoadingShow:YES];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            NSStringEncoding * usedEncoding = nil;
            //带编码头的如 utf-8等 这里会识别
            NSString *body = [NSString stringWithContentsOfURL:url usedEncoding:usedEncoding error:nil];
            if (!body){
                //如果之前不能解码，现在使用GBK解码
                body = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
            }
            if (!body) {
                //再使用GB18030解码
                body = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (body) {
                    [weakSelf.webView loadHTMLString:[NSString yj_adaptWebViewForHtml:body] baseURL:url];
                }else {
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    request.timeoutInterval = 15;
                    [weakSelf.webView loadRequest:request];
                }
            });
        });
    }else{
        [self setViewLoadingShow:YES];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.isLoadPdfSuccess = NO;
    [self setTextLoadError:@"文件加载失败"];
    [self setViewLoadErrorShow:YES];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self.ResFileExtension.lowercaseString containsString:@"pdf"]) {
        self.isLoadPdfSuccess = YES;
    }else{
         self.isLoadPdfSuccess = NO;
    }
     [self setViewLoadingShow:NO];
}

#pragma mark - Empty
- (void)setViewLoadingShow:(BOOL)show{
    [self.viewLoadError removeFromSuperview];
    [self.viewNoData removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoading show:show];
    
}
- (void)setViewNoDataShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewLoadError removeFromSuperview];
    [self setShowOnBackgroundView:self.viewNoData show:show];
    
}

- (void)setViewLoadErrorShow:(BOOL)show{
    [self.viewLoading removeFromSuperview];
    [self.viewNoData removeFromSuperview];
    [self setShowOnBackgroundView:self.viewLoadError show:show];
    
}
- (void)setShowOnBackgroundView:(UIView *)aView show:(BOOL)show {
    if (!aView) {
        return;
    }
    if (show) {
        if (aView.superview) {
            [aView removeFromSuperview];
        }
        [self.view addSubview:aView];
        [self.view bringSubviewToFront:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }else {
        [aView removeFromSuperview];
    }
}
- (void)setTextNoData:(NSString *)textNoData{
    _textNoData = textNoData;
    self.labNoData.text = textNoData;
}
- (void)setTextLoadError:(NSString *)textLoadError{
    _textLoadError = textLoadError;
    self.labLoadError.text = textLoadError;
}
- (UIView *)viewLoading {
    if (!_viewLoading) {
        _viewLoading = [[UIView alloc]init];
        _viewLoading.backgroundColor = self.view.backgroundColor;
        LGActivityIndicatorView *activityIndicatorView = [[LGActivityIndicatorView alloc] initWithType:LGActivityIndicatorAnimationTypeBallPulse tintColor:LG_ColorWithHex(0x989898)];
        [_viewLoading addSubview:activityIndicatorView];
        __weak typeof(self) weakSelf = self;
        [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.viewLoading);
            make.width.height.mas_equalTo(100);
        }];
        [activityIndicatorView startAnimating];
    }
    return _viewLoading;
}
- (UIView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[UIView alloc]init];
        _viewNoData.backgroundColor = self.view.backgroundColor;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage yj_imageNamed:@"lg_statusView_empty" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
        [_viewNoData addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewNoData);
            make.centerY.equalTo(weakSelf.viewNoData).offset(-40);
        }];
        [_viewNoData addSubview:self.labNoData];
        [self.labNoData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewNoData);
            make.left.equalTo(weakSelf.viewNoData).offset(20);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
    }
    return _viewNoData;
}
- (UIView *)viewLoadError {
    if (!_viewLoadError) {
        _viewLoadError = [[UIView alloc]init];
        _viewLoadError.backgroundColor = self.view.backgroundColor;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage yj_imageNamed:@"lg_statusView_error" atDir:YJTaskBundle_Cell atBundle:YJTaskBundle()]];
        [_viewLoadError addSubview:img];
        __weak typeof(self) weakSelf = self;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewLoadError);
            make.centerY.equalTo(weakSelf.viewLoadError).offset(-15);
        }];
        [_viewLoadError addSubview:self.labLoadError];
        [self.labLoadError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.viewLoadError);
            make.left.equalTo(weakSelf.viewLoadError).offset(30);
            make.top.equalTo(img.mas_bottom).offset(18);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadErrorUpdate)];
        [_viewLoadError addGestureRecognizer:tap];
    }
    return _viewLoadError;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserScript *wkImgScript = [[WKUserScript alloc] initWithSource:@"var imgs=document.getElementsByTagName('img');var maxwidth=document.body.clientWidth;var length=imgs.length;for(var i=0;i<length;i++){var img=imgs[i];if(img.width > maxwidth){img.style.width = '90%';img.style.height = 'auto';}}" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        [wkUController addUserScript:wkImgScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = wkUController;
        WKPreferences *preference = [[WKPreferences alloc]init];
        config.preferences = preference;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
- (UILabel *)labNoData{
    if (!_labNoData) {
        _labNoData = [[UILabel alloc] init];
        _labNoData.font = [UIFont systemFontOfSize:14];
        _labNoData.textAlignment = NSTextAlignmentCenter;
        _labNoData.textColor =  LG_ColorWithHex(0x989898);
        _labNoData.text = @"什么都没有";
        _labNoData.numberOfLines = 0;
    }
    return _labNoData;
}
- (UILabel *)labLoadError{
    if (!_labLoadError) {
        _labLoadError = [[UILabel alloc]init];
        _labLoadError.font = [UIFont systemFontOfSize:14];
        _labLoadError.textAlignment = NSTextAlignmentCenter;
        _labLoadError.textColor = LG_ColorWithHex(0x989898);
        _labLoadError.text = @"加载失败，轻触刷新";
        _labLoadError.numberOfLines = 0;
    }
    return _labLoadError;
}
@end
