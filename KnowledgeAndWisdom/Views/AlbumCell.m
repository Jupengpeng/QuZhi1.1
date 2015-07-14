//
//  AlbumCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-7.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithModel:(AlbumModel *)model{

    if (imageView==nil) {
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width/8, kScreenSize.width/12, kScreenSize.width*3/4.0, kScreenSize.width*1/2.0)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.shadowRadius = 5.0f;
    imageView.layer.shadowOpacity = 5.0f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 5.0f;
        [self addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"empty"]];

    if (titleLabel==nil) {

    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width/8, CGRectGetMaxY(imageView.frame)+20, kScreenSize.width*3/4.0, kScreenSize.width/16)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    titleLabel.text = model.title;

    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
