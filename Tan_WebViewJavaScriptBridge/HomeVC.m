//
//  HomeVC.m
//  Tan_WebViewJavaScriptBridge
//
//  Created by PX_Mac on 16/7/23.
//  Copyright © 2016年 PX_Mac. All rights reserved.
//

#import "HomeVC.h"
#import "WebViewJavascriptBridge.h"
#import "LoginVC.h"

@interface HomeVC () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWebView]; //初始化webView
}

/** 给webView加载页面 */
- (void)initWebView{
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {}];
    
    //WebView加载数据
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Home" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
    //bridge注册js调用去领奖方法
    [_bridge registerHandler:@"js_Call_Objc_Prize" handler:^(id data, WVJBResponseCallback responseCallback) {
        //模拟判断是否登录
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        
        if (userName){
            //已登录, 领奖次数加1
            static NSInteger prizeNum = 0;
            prizeNum++;
            
            //调用js，把最新的值传到js去:objc_Call_JS_UpdateNum
            [_bridge callHandler:@"objc_Call_JS_UpdateNum" data:@{@"num": @(prizeNum)} responseCallback:^(id response) {
            }];

            return;
        }
        
        //没登录，去登陆
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"不好意思，还没登录呢，是否马上去登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    //注册js调用退出事件
    [_bridge registerHandler:@"js_Call_Objc_Logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"]; //删除登录信息
        
        //没登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"退出成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *vc = [sb instantiateViewControllerWithIdentifier:@"LoginVCXM"];
        
        if (vc){
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
