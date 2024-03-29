//
//  PciStoryCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-2.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "PicStoryCell.h"
@implementation PicStoryCell

- (void)awakeFromNib {
//    [self initUI];
}

//定义为自己的imageVIew
@synthesize imageView  =_imageView;
-(void)initUI{
    if (self.MyLabel==nil) {
        self.MyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, kScreenSize.width-20-(kScreenSize.height-70)*5/24, (kScreenSize.height-70)/6-10)];
        //这边给cell加边框
        self.MyLabel.layer.cornerRadius  = 5;
        //字体自适应
        self.MyLabel.adjustsFontSizeToFitWidth = YES;
        self.MyLabel.numberOfLines = 0;
        
        [self addSubview:self.MyLabel];
    }
    if (self.imageView==nil) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.MyLabel.frame)+10, 10, self.MyLabel.frame.size.height*11/10.0, self.MyLabel.frame.size.height)];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
    }

    
    
}

-(void)initUIWithNoImage{
    if (self.MyLabel==nil) {
        self.MyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenSize.width-20, (kScreenSize.height-70)/6-10)];
        //这边给cell加边框
        self.MyLabel.adjustsFontSizeToFitWidth = YES;

        self.MyLabel.layer.cornerRadius  = 5;
        self.MyLabel.numberOfLines = 0;
        //        self.MyLabel.backgroundColor = [UIColor lightGrayColor];
        
    }
}


- (void)showDataWithModel:(StoryModel *)model{
    if (model.images!=nil) {
    [self initUI];
    self.MyLabel.text = model.title;
        
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"empty"]];
        [self addSubview:self.imageView];
        [self addSubview:self.MyLabel];

    }else{
        
        [self initUIWithNoImage];
        self.MyLabel.text = model.title;
        [self addSubview:self.MyLabel];

        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
