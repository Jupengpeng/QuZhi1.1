//
//  NewsViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-6-30.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "NewsViewController.h"
#import "SVProgressHUD.h"
#define kNum     arc4random()%256/255.0
#define KcellId @"PicStoryCell"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation NewsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    [self.tabBarController.tabBar setHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.dataArr ==nil) {
        self.dataArr = [[NSMutableArray alloc]init];
    }
    [self createTableView];
}

-(void)createTableView{
    if (self.tableView==nil) {

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kScreenSize.width , kScreenSize.height-68) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    }
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        __weak typeof (self) weakSelf = self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [SVProgressHUD dismiss];
            if (weakSelf.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
        
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NewsModel * newsModel = [[NewsModel alloc]init];
            [newsModel setValuesForKeysWithDictionary:dict];
            [weakSelf showDataWithNewsModel:newsModel];
            for (NSDictionary * storyDict in newsModel.stories) {
                StoryModel *storyModel = [[StoryModel alloc]init];
                [storyModel setValuesForKeysWithDictionary:storyDict];
                [weakSelf.dataArr addObject:storyModel];
            }
            [weakSelf endRefreshing];
            [weakSelf.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
    
}
-(void)showDataWithNewsModel:(NewsModel *)model{
    if (model.image==nil) {
        return;
    }
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width/1.2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.background] placeholderImage:[UIImage imageNamed:@"empty"]];
    self.tableView.tableHeaderView = imageView;
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(imageView.frame)- kScreenSize.width/6-10, kScreenSize.width-40, kScreenSize.width/6)];
    label.text = model.description;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:19];
    label.textColor = [UIColor whiteColor];
    [imageView addSubview:label];
    
    
}

//创建下拉刷新和上拉加载
-(void)ceateRefreshView{
    
    __weak typeof (self) weakSelf = self;//弱引用
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        
        weakSelf.isRefreshing = YES;//标记正在刷新
        
        NSString *url = nil;
        url = weakSelf.url;
        
        
        [weakSelf addTaskWithUrl:url isRefresh:YES];
        
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        NSString * url =nil;
        StoryModel * model = [weakSelf.dataArr lastObject];
        url = [NSString stringWithFormat:kNewsBeforeUrl,weakSelf.urlId,model.id];
        [weakSelf addTaskWithUrl:url isRefresh:NO];
    }];
    
    
}
//结束刷新
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;//标记刷新结束
        //正在刷新 就结束刷新
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma  mark- <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenSize.width*1.78-70)/6+10;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PicStoryCell * cell=nil;
    if (cell==nil) {
        
    
     cell = [[PicStoryCell alloc]init];
    }
    StoryModel * model = self.dataArr[indexPath.row];
    
    
    
    [cell showDataWithModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryModel * model = self.dataArr[indexPath.row];
    StoryDetailViewController * dVC = [[StoryDetailViewController alloc]init];
    dVC.storyId = model.id;
    dVC.myRow =(int)indexPath.row;
    dVC.dataArr = self.dataArr;
    dVC.title = model.title;
    dVC.type = rootType;
    //点击后效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.navigationController pushViewController:dVC animated:YES];

}
//设置滚动自动隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.tabBarController.tabBar.alpha=1-self.tableView.contentOffset.y/200;
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha=1;
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha=1;
        
    }];
}
@end
