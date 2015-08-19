//
//  hintView.h
//  tt3
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSInteger index);

@interface hintView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *hintMessage;
@property (nonatomic,strong) buttonBlock btnBlock;

@end
