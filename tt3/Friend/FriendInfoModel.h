//
//  FriendInfoModel.h
//  tt3
//
//  Created by hsm on 15/7/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface FriendInfoModel : NSObject
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

@property (nonatomic,strong) NSString *jid;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *headImg;
@property (nonatomic,strong) NSString *group;      //所在的列表
@property (nonatomic,strong) NSString *subscription;
@property (nonatomic,assign) BOOL     gender;


-(void)setFriendInfoModelWith:(NSXMLElement *)item;

@end
