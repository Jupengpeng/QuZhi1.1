//
//  DetailViewController.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-6.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailModel.h"
#import "AFNetworking.h"
#import "StoryModel.h"
#import "SVProgressHUD.h"
#import "DBmanager.h"
typedef void (^RefreshCollectBLock) (int storyId);

@interface StoryDetailViewController : BaseViewController
{
    RefreshCollectBLock _myBlock;
    
}
@property (nonatomic) int storyId; ;
@property (nonatomic) int myRow ;
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,strong) UIButton * button;
@property (nonatomic,copy) NSString * type;

- (void)getRefreshAction:(RefreshCollectBLock)myBlock;

@end
