//
//  CommentModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-11.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * avatar;


@end
