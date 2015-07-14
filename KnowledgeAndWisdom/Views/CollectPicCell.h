//
//  CollectPicCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-10.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"
@interface CollectPicCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * smallImagView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) MyButton * deleteButton;

- (void)showDataWithModel:(PicDetailModel *)model;

@end
