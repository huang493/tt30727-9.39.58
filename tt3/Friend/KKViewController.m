//
//  KKViewController.m
//  tt3
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "KKViewController.h"
#import "KKLoginController.h"
#import "KKChatController.h"
#import "KKChatDelegate.h"
#import "AppDelegate.h"
#import "AddFriendViewController.h"
#import "MBProgressHUD.h"
#import "hintView.h"
#import "DataBaseManager.h"


@interface KKViewController ()<UITableViewDataSource,UITableViewDelegate,KKChatDelegate>
{
    
    NSMutableArray *sectionTitles;
    //在线用户
    NSMutableArray *onlineUsers;
    NSMutableArray *offlineUsers;
    AppDelegate    *appDel;
    NSString       *currentUserID;
}
@end

@implementation KKViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        sectionTitles = [NSMutableArray array];
        onlineUsers   = [NSMutableArray array];
        offlineUsers  = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    [self setSectionTitles];
    [self addNotifications];
    
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
    
    
    appDel = [self getDelegate];
    appDel.chatDelegate = self;

}

#pragma -mark Notification and Action

-(void)addNotifications{
    NSNotificationCenter *noc = [NSNotificationCenter defaultCenter];
    [noc addObserver:self selector:@selector(receiveSubscriptionRequestNoc:) name:@"ReceiveSubscriptionRequest" object:nil];
}

-(void)receiveSubscriptionRequestNoc:(NSNotification *) no {
    NSLog(@"noc:%@",no);
    __weak KKViewController  *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic             = no.object;
        XMPPRoster   *roster          = dic[@"XMPPRoster"];
        XMPPPresence *presence        = dic[@"XMPPPresence"];
        
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        __weak MBProgressHUD *weakhud = hud;
        
        hintView *hintV               = [[NSBundle mainBundle] loadNibNamed:@"hintView" owner:self options:nil][0];
        hintV.hintMessage.text        = [NSString stringWithFormat:@"%@请求添加为好友。",[presence from]];
        hintV.btnBlock                = ^(NSInteger index){
                                            if (index == 1) {
                                                [roster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
                                            }
                                            else{
                                                [roster rejectPresenceSubscriptionRequestFrom:[presence from]];
                                            }
                                            weakhud.hidden = YES;
        };
        hud.customView                = hintV;
        hud.color                     = [UIColor lightGrayColor];
        hud.mode                      = MBProgressHUDModeCustomView;
    });
}



-(void)setNav{
    
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    NSString *accountStr = [defau objectForKey:@"userid"];
    accountStr = [accountStr componentsSeparatedByString:@"@"].count>0 ?  [accountStr componentsSeparatedByString:@"@"][0]:@"";
    self.navigationItem.title = [NSString stringWithFormat:@"%@",accountStr];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    
}
-(void)setSectionTitles{
    [sectionTitles addObject:@"online friends"];
    [sectionTitles addObject:@"offline friends"];
}
-(void)getSubscribed{
    XMPPRosterCoreDataStorage *rosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
    XMPPRoster *roster = [[XMPPRoster alloc] initWithRosterStorage:rosterCoreDataStorage];
    [roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)addFriend:(UIButton *)sender
{
    AddFriendViewController *addFirendVC = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFirendVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    BOOL needReLogin = NO;
    if (!currentUserID) {
        currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        needReLogin   = YES;
    }
    else{
        if (![currentUserID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]]) {
            currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
            needReLogin = YES;
        }
    }
    
    if (!currentUserID) {
        //设定用户
        [self Account:self];
        return;
    }
    
    if (needReLogin) {
        [[self getDelegate] disconnect];
        if ([[self getDelegate] connect]) {
            NSLog(@"------------>>>Account location login success");
        }
    }
}

-(AppDelegate *)getDelegate
{
    return  (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return del.xmppStream;
}

- (IBAction)Account:(id)sender {
    KKLoginController *loginVC = [[KKLoginController alloc] init];
    __weak KKViewController *weakSelf = self;
    loginVC.newAccount = ^(NSString *userid,NSString *password,NSString*server){
        [onlineUsers removeAllObjects];
        [weakSelf.tView reloadData];
    };
    [self.navigationController pushViewController:loginVC animated:YES];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if (![onlineUsers containsObject:buddyName]) {
        [onlineUsers addObject:buddyName];
        [offlineUsers removeObject:buddyName];
        [self.tView reloadData];
    }
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [onlineUsers removeObject:buddyName];
    [offlineUsers addObject:buddyName];
    [self.tView reloadData];
    
}

-(void)didDisconnect{

    NSLog(@"disconnect");
}


#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return sectionTitles[section];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [onlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = onlineUsers[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKChatController *chatVC = [[KKChatController alloc] init];
    chatVC.chatWithUser = onlineUsers[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
