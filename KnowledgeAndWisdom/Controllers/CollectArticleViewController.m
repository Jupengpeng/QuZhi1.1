//
//  CollectArticleViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-9.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "CollectArticleViewController.h"
#import "DBmanager.h"
#import "StoryDetailViewController.h"
#import "CollectArticleCell.h"
#define cellId @"CollectArticleCell"

@interface CollectArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UILabel * label;

@end

@implementation CollectArticleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"用户" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initFirst];
    
    
}
- (void)btnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initFirst{
    NSArray * dataArr = [[DBmanager sharedManager] readArticleModels];
    self.dataArray = [[NSMutableArray alloc]initWithArray:dataArr];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kScreenSize.width, kScreenSize.height-64)  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.rowHeight = kRowheight/2.0;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[CollectArticleCell class] forCellReuseIdentifier:cellId];
    
}

#pragma  mark -<UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];


    DetailModel * model = self.dataArray[indexPath.row];


    [cell showDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.selected = NO;
    
    StoryDetailViewController * svc = [[StoryDetailViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    [svc getRefreshAction:^(int storyId) {
        [weakSelf initFirst];
        [weakSelf.tableView reloadData];
    }];
    
    DetailModel * model = self.dataArray[indexPath.row];
    svc.myRow = (int)indexPath.row;
    svc.dataArr = self.dataArray;
    svc.title = model.title; 
    svc.storyId  = model.id;
    svc.type = previousType;
    [self.navigationController pushViewController:svc animated:YES];
    
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];

    [_tableView setEditing:editing animated:YES];

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel * model = self.dataArray[indexPath.row];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [[DBmanager sharedManager]deleteModelForStoryId:model.id];
    NSArray * indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
