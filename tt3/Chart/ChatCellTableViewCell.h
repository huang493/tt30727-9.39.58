//
//  ChatCellTableViewCell.h
//  tt3
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"

typedef void(^senderImgClickBlock)(NSString *name);

@interface ChatCellTableViewCell : UITableViewCell

@property (weak, nonatomic ) IBOutlet UILabel             *timeLabel;
@property (weak, nonatomic ) IBOutlet UIImageView         *senderImgView;
@property (weak, nonatomic ) IBOutlet UILabel             *messageLabel;

@property (nonatomic,strong) ChatMessageModel    *model;
@property (nonatomic,strong) UIImageView         *bgImgView;
@property (nonatomic,assign) CGFloat             cellHeigh;
@property (nonatomic,strong) senderImgClickBlock imgClickBlock;




-(void)loadDatasFromChatMessageModel:(ChatMessageModel *)model;


@end
