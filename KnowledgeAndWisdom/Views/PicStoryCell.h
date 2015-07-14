//
//  PciStoryCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-2.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface PicStoryCell : UITableViewCell
{
    UIImageView * _imageView;
    UILabel * _MyLabel;
}
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * MyLabel;

-(void)initUI;
- (void)showDataWithModel:(StoryModel *)model;
@end
