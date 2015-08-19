//
//  sectionView.h
//  ModelText
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 hsm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef   void(^sectionBlock)(NSInteger index);
@interface SectionView : UIView

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,assign) NSArray *sectionNumber;
@property (nonatomic,strong) sectionBlock clickSection;
-(void)addSubviews;
@end
