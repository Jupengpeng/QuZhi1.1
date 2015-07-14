//
//  CommentCell.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-11.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

#import "UIImageView+WebCache.h"
@interface CommentCell : UITableViewCell

@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UITextView * textView;;
@property (nonatomic,strong) UILabel * authorLabel;
- (void)showDataWithCommentModel:(CommentModel *)model;

@end
