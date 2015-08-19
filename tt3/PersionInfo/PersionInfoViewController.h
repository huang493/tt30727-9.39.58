//
//  PersionInfoViewController.h
//  tt3
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface PersionInfoViewController : UIViewController<KKVcarDelegate>

@property (nonatomic,strong) NSString *messageFrom;
@property (nonatomic,strong) XMPPJID  *jid;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

@end
