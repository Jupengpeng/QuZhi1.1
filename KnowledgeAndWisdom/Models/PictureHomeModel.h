//
//  PictureHomeModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-7.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseModel.h"
@interface PictureHomeModel : BaseModel

@property (nonatomic,copy) NSString * page;
@property (nonatomic,copy) NSString * pagecount;
@property (nonatomic,copy) NSString * total;
@property (nonatomic,strong)NSArray *album;


@end
