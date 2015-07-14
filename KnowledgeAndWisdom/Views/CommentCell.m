//
//  CommentCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-11.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "CommentCell.h"
#import "LZXHelper.h"
@implementation CommentCell

- (void)awakeFromNib {

}

- (void)initCell{
    if (self.iconImageView==nil) {
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, kScreenSize.width/10,  kScreenSize.width/10)];
        self.iconImageView.layer.cornerRadius =kScreenSize.width/20;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.iconImageView.layer.masksToBounds=YES;
        [self addSubview:self.iconImageView];
    }
    if (self.authorLabel ==nil) {
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+4, 10, kScreenSize.width*2/3.0, kScreenSize.width/15)];
        [self addSubview:self.authorLabel];
    }
    if (self.textView==nil) {
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.iconImageView.frame), CGRectGetMaxY(self.authorLabel.frame), kScreenSize.width*0.9-40, kScreenSize.width/5)];
        self.textView.editable = NO;
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.layer.borderWidth= 0.9f;
        self.textView.layer.borderColor = myBlue.CGColor;
        self.textView.layer.masksToBounds=YES;
        self.textView.layer.cornerRadius =5;
        [self addSubview:self.textView];
    }
    
}
- (void)showDataWithCommentModel:(CommentModel *)model{
    [self initCell];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"empty"]];
    self.authorLabel.text  = model.author;
    self.authorLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
    self.textView.text = model.content;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
