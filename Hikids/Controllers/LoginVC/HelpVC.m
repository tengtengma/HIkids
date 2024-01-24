//
//  HelpVC.m
//  Hikids
//
//  Created by 马腾 on 2024/1/24.
//

#import "HelpVC.h"
#import <WebKit/WebKit.h>
@interface HelpVC ()
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"よくある質問";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HelpURL]]];
    [self.view addSubview:self.webView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:81.0/255.0 green:140.0/255.0 blue:223.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
    
//    //添加监测网页加载进度的观察者
//        [self.webView addObserver:self
//                       forKeyPath:@"estimatedProgress"
//                          options:0
//                          context:nil];
}
////kvo 监听进度 必须实现此方法
//-(void)observeValueForKeyPath:(NSString *)keyPath
//                     ofObject:(id)object
//                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                      context:(void *)context{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == _webView) {
//       NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
//        self.progressView.progress = _webView.estimatedProgress;
//        if (_webView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else if([keyPath isEqualToString:@"title"]
//             && object == _webView){
//        self.navigationItem.title = _webView.title;
//    }else{
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}

- (void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma makr - LazyLoad -
- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, BW_TopHeight, self.view.bounds.size.width, self.view.bounds.size.height) configuration:config];
        
    }
    return _webView;
}


@end
