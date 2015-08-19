//
//  FriendInfoModel.m
//  tt3
//
//  Created by hsm on 15/7/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FriendInfoModel.h"

@implementation FriendInfoModel


/* friends table structure
 @[
 @"id:integer primary key autoincrement",
 @"jid:text",            //JID
 @"nickName:text",       //昵称
 @"gender:bool",         //性别
 @"subscription:bool",   //订阅状态
 @"headImg:text"         //头像
 ];
 */


-(void)setFriendInfoModelWith:(NSXMLElement *)item{
    
    _subscription = [item attributeStringValueForName:@"subscription"];
    _jid = [item attributeStringValueForName:@"jid"];
    
}


@end
