//
//  AlbumCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-7.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "UIImageView+WebCache.h"
#import "PictureDetailViewController.h"
@interface AlbumCell : UITableViewCell
{
    UIImageView * imageView;
    UILabel * titleLabel;
}
- (void)showDataWithModel:(AlbumModel *)model;


@end
