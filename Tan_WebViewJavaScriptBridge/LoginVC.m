//
//  LoginVC.m
//  Tan_WebViewJavaScriptBridge
//
//  Created by PX_Mac on 16/7/23.
//  Copyright © 2016年 PX_Mac. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //保存登录信息
    [[NSUserDefaults standardUserDefaults] setObject:_nameTxt.text forKey:@"userName"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
