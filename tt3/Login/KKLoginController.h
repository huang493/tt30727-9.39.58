//
//  KKLoginController.h
//  tt3
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changAccount)(NSString *userid,NSString *password,NSString *server);
@interface KKLoginController : UIViewController
@property  (nonatomic,strong) changAccount newAccount;

@end
