//
//  NewsModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-6.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel

@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *background;
@property (nonatomic,copy) NSString * image;
@property (nonatomic,strong) NSArray *  stories;
@property (nonatomic,strong) NSArray * editors;
@property (nonatomic,copy) NSString * name;



@end
