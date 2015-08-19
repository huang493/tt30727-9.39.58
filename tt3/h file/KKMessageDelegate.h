//
//  messageDelegate.h
//  tt3
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import "ChatMessageModel.h"
@protocol KKMessageDelegate <NSObject>

-(void)newMessageReceived:(ChatMessageModel*)message;

@end
