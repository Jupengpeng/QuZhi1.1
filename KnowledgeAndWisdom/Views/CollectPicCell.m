//
//  CollectPicCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-10.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "CollectPicCell.h"
#import "DBmanager.h"
@implementation CollectPicCell



- (void)initUI{
    if (self.smallImagView==nil) {
        self.smallImagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kScreenSize.width-40)/2, (kScreenSize.width-40)*3/5)];
        self.smallImagView.backgroundColor = [UIColor blackColor];
        [self.smallImagView setContentMode:UIViewContentModeScaleAspectFit];
        self.smallImagView.layer.borderWidth = 2.0f;
        self.smallImagView.layer.borderColor = myBlue.CGColor;
        [self addSubview:self.smallImagView];
    }
    if (self.titleLabel==nil) {
        self.titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.smallImagView.frame), (kScreenSize.width-40)/3, (kScreenSize.width-40)/10)];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.layer.borderWidth = 2.0f;
        self.titleLabel.layer.borderColor = myBlue.CGColor;
        self.titleLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:self.titleLabel];
    }

    
}


- (void)showDataWithModel:(PicDetailModel *)model{
    [self initUI];
    [self.smallImagView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"empty"]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth= YES;
    self.titleLabel.text = model.title;
}




@end
