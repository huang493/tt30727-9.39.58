//
//  BaseViewController.m
//  tt3
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
-(void)showHud:(BOOL)hidden{
    [_hud hide:hidden];
}

-(void)showHudOnKeyWindowTitle:(NSString *)title after:(CGFloat)seconds{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = title;
    if (seconds > 0) {
        BaseViewController *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.hud hide:YES];
        });
    }
}
@end
