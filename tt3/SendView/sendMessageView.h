//
//  sendMessageView.h
//  tt3
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMacro.h"

typedef void(^sendMessageBlock)(NSString *message);
typedef void(^sendBtnClick)(NSString *message,NSData *data, enum MessageType type);
typedef void(^changHeighBlock)(CGFloat heigh);
@interface sendMessageView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) sendBtnClick     clickBlock;
@property (nonatomic,strong) changHeighBlock  chanegeHiBlock;
@property (nonatomic,strong) UITextField      *messageTF;

@end
