//
//  sectionView.m
//  ModelText
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 hsm. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView
{
    BOOL isImg;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self  = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)addSubviews{
    
    CGFloat width = 0.0;
    CGFloat heigh = self.frame.size.height;
    if (_titles.count == 0 && _imgs.count !=0) {
        isImg = YES;
        width  = self.frame.size.width / _imgs.count;
    }
    else if(_titles.count!=0 && _imgs.count == 0){
        isImg = NO;
        width  = self.frame.size.width / _titles.count;
    }
    else if(_titles.count!=0 && _imgs.count != 0){
        isImg = YES;
        width  = self.frame.size.width / _titles.count;
    }
    else{
        NSLog(@"titles and imgs is enpty");
        return;
    }

    [_imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        if (isImg) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, heigh)];
            imgV.image = (UIImage *)obj;// [(UIImage *)obj imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [btn addSubview:imgV];
            
        }
        else{
            [btn setTitle:obj forState:UIControlStateNormal];
        }
        
        btn.frame = CGRectMake(width*idx, 0, width, heigh);
        btn.tag = idx;
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];

}

-(void)tapAction:(UIImageView *)sender{
    
    if (_clickSection) {
        _clickSection(sender.tag);
    }
}



@end
