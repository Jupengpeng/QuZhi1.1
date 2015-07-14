//
//  LatestModel.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-2.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LatestModel : NSObject

@property (nonatomic,copy) NSString * date;
@property (nonatomic,strong) NSArray * stories;
@property (nonatomic,strong) NSArray * top_stories;

@end
