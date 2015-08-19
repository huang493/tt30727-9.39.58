//
//  hintView.m
//  tt3
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "hintView.h"

@implementation hintView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView
{
    self.okBtn.layer.cornerRadius = 10.0f;
    self.cancelBtn.layer.cornerRadius = 10.0f;
    
    
    self.okBtn.clipsToBounds = YES;
    self.cancelBtn.clipsToBounds = YES;
    
    
}
- (IBAction)okClick:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(1);

    }
}

- (IBAction)cancelClick:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(2);
    }
}

@end
