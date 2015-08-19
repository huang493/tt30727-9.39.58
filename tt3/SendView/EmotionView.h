//
//  EmotionView.h
//  tt3
//
//  Created by hsm on 15/8/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMacro.h"
#import "SectionView.h"

typedef void(^selectItemBlock)(NSString *name,NSData *data,enum MessageType type);

@interface EmotionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIScrollView           *emotionScroll;
@property (nonatomic,strong) SectionView            *sectionView;
@property (nonatomic,strong) UICollectionView       *collectionView;
@property (nonatomic,strong) UIPageControl          *pageC;
@property (nonatomic,strong) UISegmentedControl     *segmentC;
@property (nonatomic,assign) enum EmotionType       emotionType;
@property (nonatomic,strong) selectItemBlock        selectPictureBlock;

@end
