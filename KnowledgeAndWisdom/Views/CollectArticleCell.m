//
//  CollectArticleCell.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-13.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "CollectArticleCell.h"

@implementation CollectArticleCell

- (void)awakeFromNib {

}

- (void)showDataWithModel:(DetailModel *)detailModel {
    if (self.label==nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenSize.width-40, kRowheight-20)];

        
    }
    self.label.text = detailModel.title;
    self.label.layer.borderWidth = 2.0f;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.layer.borderColor = myBlue.CGColor;
    self.label.numberOfLines= 0;
    
    [self addSubview:self.label];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
