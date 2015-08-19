//
//  KKLoginController.m
//  tt3
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "KKLoginController.h"
#import "AppDelegate.h"
#import "DataBaseManager.h"
#import "MBProgressHUD.h"
#import "XMPPFramework.h"

@interface KKLoginController () <UITextFieldDelegate>
{
    UITextField *accountTextField;
    UITextField *passwordTextField;
    UITextField *serverTextField;
    MBProgressHUD *hub;
}
@end

@implementation KKLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNav];
    [self addSubViews];
    [self addNotifications];

}

-(void)initNav{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"Login" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(loginActopn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

-(void)addSubViews{
    UILabel *accountlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 30)];
    accountlabel.text = @"Account:";
    [self.view addSubview:accountlabel];
    
    
    UILabel *passwordlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 100, 30)];
    passwordlabel.text = @"Password:";
    [self.view addSubview:passwordlabel];
    
    
    UILabel *serverlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 30)];
    serverlabel.text = @"Server:";
    [self.view addSubview:serverlabel];
    
    
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 100, 200, 30)];
    accountTextField.layer.borderWidth = 1.0;
    accountTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accountTextField.layer.cornerRadius = 3.0;
    accountTextField.delegate = self;
    [self.view addSubview:accountTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 150, 200, 30)];
    passwordTextField.layer.borderWidth = 1.0;
    passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTextField.layer.cornerRadius = 3.0;
    [self.view addSubview:passwordTextField];
    
    serverTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 200, 200, 30)];
    serverTextField.layer.borderWidth = 1.0;
    serverTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    serverTextField.layer.cornerRadius = 3.0;
    [self.view addSubview:serverTextField];
}

-(void)addNotifications{
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(receivesNotAuthenticateResult:) name:@"AuthenticateResult" object:nil];
}

-(void)receivesNotAuthenticateResult:(NSNotification *)no{
    
    hub.mode = MBProgressHUDModeText;
    NSXMLElement *err = (NSXMLElement *)no.userInfo;
    if (err) {
        hub.labelText = [NSString stringWithFormat:@"%@",err];
        hub.detailsLabelText = @"please try again.";
    }
    else{
        hub.labelText = @"login success!";
        hub.detailsLabelText = @"";
        [self loginSuccessAction];
    }
    
    __weak KKLoginController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
        hub.hidden = YES;
        
        //服务器登入成功
        if ([hub.detailsLabelText isEqualToString:@""]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
        //服务器登入失败
            //移除失败的用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"userid"];
            [defaults removeObjectForKey:@"password"];
            [defaults removeObjectForKey:@"server"];
            [defaults synchronize];
        }
    });
    
}

-(void)loginSuccessAction{
    //创建保存账号资料文件夹
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [NSString stringWithFormat:@"%@/%@",path,accountTextField.text];
    BOOL result = [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"------------>>>create file path:%@",path);
    
    
    //创建数据库
    if (result) {
        DataBaseManager *dbManager = [DataBaseManager shareDataBaseManager];
        FMDatabase *db = [dbManager createDBWithPath:path];
        NSArray *params = @[@"id:integer primary key autoincrement",
                            @"messageTo:text",              //toJID
                            @"messageFrom:text",            //fromJID
                            @"isme:bool",                   //是否是我
                            @"isread:bool",                 //是否已读
                            @"isgroup:bool",                //是否群
                            @"time:datetime",               //时间 YYYY-MM-DD HH:MM:SS 支持的范围是'1000-01-01 00:00:00'到'9999-12-31 23:59:59'
                            @"message:text",                //文本信息
                            @"photo:text",                  //图片地址
                            @"photoIndex:integer",          //图片偏移
                            @"sound:text"                   //音频地址
                            ];
        
        if (![dbManager createTable:@"messages" withParams:params toDataBase:db]) {
            NSLog(@"table messages create fial");
        }
        
        params = @[
                   @"id:integer primary key autoincrement",
                   @"jid:text",            //JID
                   @"nickName:text",       //昵称
                   @"gender:bool",         //性别
                   @"subscription:text",   //订阅状态
                   @"headImg:text"         //头像
                   ];
        if (![dbManager createTable:@"friends" withParams:params toDataBase:db]) {
            NSLog(@"table friends create fial");
        }
        
        [dbManager closeDB:db];
    }
    
    
    //保存为当前用户的信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accountTextField.text forKey:@"userid"];
    [defaults setObject:passwordTextField.text forKey:@"password"];
    [defaults setObject:serverTextField.text forKey:@"server"];
    [defaults synchronize];
    
    
    if (_newAccount) {
        _newAccount(accountTextField.text,passwordTextField.text,serverTextField.text);
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    accountTextField.text  = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    serverTextField.text   = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [accountTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [serverTextField resignFirstResponder];
}


-(void)loginActopn:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![accountTextField.text isEqualToString:[defaults objectForKey:@"userid"]]) {
        if (accountTextField.text && passwordTextField.text && serverTextField.text) {
            
            if (hub == nil) {
                hub = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
            }
            hub.mode = MBProgressHUDModeIndeterminate;
            hub.labelText = @"loging...";
            hub.detailsLabelText = @"please waiting...";
            
            
            [defaults setObject:accountTextField.text forKey:@"userid"];
            [defaults setObject:passwordTextField.text forKey:@"password"];
            [defaults setObject:serverTextField.text forKey:@"server"];
            
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [del disconnect];
            [del connect];
        }
    }
    
    [defaults synchronize];

}


-(BOOL)validateWithUser:(NSString *)userText andPass:(NSString *)passText andServer:(NSString *)serverText{
    
    if (userText.length > 0 && passText.length > 0 && serverText.length > 0) {
        return YES;
    }
    
    return NO;
}

#pragma -mark ----------UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSArray *arr = [textField.text componentsSeparatedByString:@"@"];
    if (arr.count>1) {
        serverTextField.text = arr[1];
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
