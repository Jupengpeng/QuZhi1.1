//
//  PictureDetailViewController.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-7.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "PicSecPageModel.h"
#import "PicDetailModel.h"
#import "AlbumDetailCell.h"
#import "PicDetailModel.h"
@interface PictureDetailViewController : BaseViewController

@property (nonatomic,copy) NSString * albumId;

@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic)NSInteger savedIndex ;

@end
