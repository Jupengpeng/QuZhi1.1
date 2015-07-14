//
//  DetailModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-6.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseModel.h"

@interface DetailModel : BaseModel

@property (nonatomic,copy) NSString * body;
@property (nonatomic,copy) NSString * share_url;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,strong) NSArray *recommenders;
@property (nonatomic)int id ;



@end
