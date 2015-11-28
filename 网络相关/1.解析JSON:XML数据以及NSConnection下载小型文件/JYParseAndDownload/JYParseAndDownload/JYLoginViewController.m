//
//  JYLoginViewController.m
//  JYParseAndDownload
//
//  Created by joyann on 15/11/6.
//  Copyright © 2015年 Joyann. All rights reserved.
//

#import "JYLoginViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"

static NSString * JYBaseURLString = @"http://120.25.226.186:32812/login?";

@interface JYLoginViewController ()
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation JYLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addSubviews];
    
    [self setConstrains];
}

#pragma mark - Add Subviews

- (void)addSubviews
{
    // 添加账号textField
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.backgroundColor = [UIColor blueColor];
    userNameTextField.placeholder = @"请输入账号";
    [self.view addSubview:userNameTextField];
    self.userNameTextField = userNameTextField;
    
    // 添加密码textField
    UITextField *pwdTextField = [[UITextField alloc] init];
    pwdTextField.backgroundColor = [UIColor redColor];
    pwdTextField.placeholder = @"请输入密码";
    [self.view addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    
    // 添加登录button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"登 录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.loginButton = button;
}

#pragma mark - Set Constrains

- (void)setConstrains
{
    // 设置账号textField约束
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(8);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.trailing.equalTo(self.view.mas_trailing).offset(-8);
        make.height.equalTo(@50);
    }];
    // 设置密码textField约束
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userNameTextField.mas_leading);
        make.trailing.equalTo(self.userNameTextField.mas_trailing);
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(8);
        make.height.equalTo(self.userNameTextField.mas_height);
    }];
    // 设置登录button约束
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userNameTextField.mas_leading);
        make.trailing.equalTo(self.userNameTextField.mas_trailing);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(8);
        make.height.equalTo(self.userNameTextField.mas_height);
    }];
}

#pragma mark - Login

- (void)login: (UIButton *)loginButton
{
    NSString *userName = [self.userNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *pwd = [self.pwdTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [JYBaseURLString stringByAppendingString:[NSString stringWithFormat:@"username=%@&pwd=%@&type=JSON", userName, pwd]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"登录中 ..."];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 这次在子线程中解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *errorMessage = dict[@"error"];
        NSString *successMessage = dict[@"success"];
        if (errorMessage) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD showErrorWithStatus:errorMessage];
            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD showSuccessWithStatus:successMessage];
            }];
        }
    }];
}

@end
