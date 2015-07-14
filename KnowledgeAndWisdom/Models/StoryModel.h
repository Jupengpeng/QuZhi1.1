//
//  StoriesModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-2.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseModel.h"

@interface StoryModel : BaseModel

@property (nonatomic,strong) NSArray * images;
@property (nonatomic)int id ;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * ga_prefix;


@end
