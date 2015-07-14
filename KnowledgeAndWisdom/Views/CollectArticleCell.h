//
//  CollectArticleCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-13.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface CollectArticleCell : UITableViewCell

@property (nonatomic,strong) UILabel * label ;
- (void)showDataWithModel:(DetailModel *)detailModel;
@end
