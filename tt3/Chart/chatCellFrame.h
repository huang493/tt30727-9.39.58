//
//  chatCellFrame.h
//  tt3
//
//  Created by apple on 15/8/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
#import "Tools.h"

@interface chatCellFrame :   NSObject
@property (nonatomic,assign) CGRect labelFrame;
-(void)loadDatasWithMessage:(ChatMessageModel *)model;

@end
