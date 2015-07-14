//
//  AlbumDetailCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-8.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "AlbumDetailCell.h"
@implementation AlbumDetailCell

- (void)initAlbumDetailCell{
    if (self.imageView==nil) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        //设置imageview内容自适应大小
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.imageView];
    }
}
- (void)showDataWithModel:(PicDetailModel *)model{
    [self initAlbumDetailCell];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"empty"]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

@end
