//
//  chatCellFrame.m
//  tt3
//
//  Created by apple on 15/8/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "chatCellFrame.h"

@implementation chatCellFrame

-(void)loadDatasWithMessage:(ChatMessageModel *)model{
    
    _labelFrame = CGRectMake(0, 0, 255.0/320.0*SCREENWIDTH, 0);
    _labelFrame.size.height = [Tools getHighOfString:model.message andSize:CGSizeMake(_labelFrame.size.width, 0) andFont:[UIFont systemFontOfSize:17.0]];
}

@end
