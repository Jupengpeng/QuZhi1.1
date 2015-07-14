//
//  AlbumDetailCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-8.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicDetailModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "AFNetworking.h"
@interface AlbumDetailCell : UICollectionViewCell
{
    UIImageView * _imageView;
}
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic)int count ;

- (void)showDataWithModel:(PicDetailModel *)model;


@end
