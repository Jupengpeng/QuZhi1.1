//
//  DBmanager.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-9.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailModel.h"
#import "PicDetailModel.h"
@interface DBmanager : NSObject
+ (instancetype)sharedManager;


- (NSString *)getFileFullPathWithFileName:(NSString *)fileName;
- (void)insertModel:(id)model ;
- (BOOL)isExistArticleForTitle:(NSString *)title;
- (void)deleteModelForTitle:(NSString *)title;
- (void)deleteModelForStoryId:(NSInteger )StoryId;

- (NSArray *)readArticleModels;
- (NSArray *)readArticleModelsWithTitle:(NSString *)title;
- (NSInteger)getCountsFromAppWithTitle:(NSString *)title;

- (void)createPicTable;
- (void)insertPicModel:(PicDetailModel *)model;
- (void)deleteModelForPicId:(NSString *)picId;
- (NSArray *)readPicModels;


@end
