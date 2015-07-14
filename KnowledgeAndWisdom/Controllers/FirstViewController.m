//
//  FirstViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-6-30.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "FirstViewController.h"
#import "Top_storiesModel.h"
#import "StoryModel.h"
#import "AFNetworking.h"
#import "PicStoryCell.h"
#import "LatestModel.h"
#import "Top_storiesModel.h"
#import "UIButton+WebCache.h"
#import "JHRefresh.h"
#import "StoryDetailViewController.h"
#import "SVProgressHUD.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    UIScrollView * _scrollView;
    AFHTTPRequestOperationManager * _manager;
    BOOL _isRefreshing;
}
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic,strong) NSMutableArray * cellModelArr;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) LatestModel * latestModel;
@property (nonatomic,strong) NSMutableArray * imagesArray;
@property (nonatomic,strong) NSString * currentDate;

@property (nonatomic,strong) NSMutableArray * extraDataArr;
@property (nonatomic,strong) NSMutableArray * topArr;
@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
    [self.tabBarController.tabBar setHidden:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.cellModelArr = [[NSMutableArray alloc]init];
    [self addTaskWithUrl:kFirstScrollUrl isRefresh:YES];
    [self createTableView];
    [self ceateRefreshView];
    
    
}

-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh{
    if (self.dataArray ==nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    __weak typeof(self) weakSelf = self;

    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [SVProgressHUD dismiss];
            if (weakSelf.isRefreshing==YES) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.extraDataArr removeAllObjects];
            }
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            LatestModel * latestModel = [[LatestModel alloc]init];
            [latestModel setValuesForKeysWithDictionary:dict];
            //将最近页面保存下来
            if (latestModel.top_stories!=nil) {
                weakSelf.latestModel = [[LatestModel alloc]init];
                weakSelf.latestModel = latestModel;
            }
            
            weakSelf.currentDate = latestModel.date;
            [weakSelf.dataArray addObject:latestModel];
            
            [weakSelf showDataWithModel:latestModel];
            [weakSelf.tableView reloadData];
        }
        [weakSelf endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
}
//构建首页scrollview
-(void)showDataWithModel:(LatestModel *)model{
    CGFloat  w= kScreenSize.width;;
    CGFloat h = kScreenSize.width*50/51;
    if (self.topArr ==nil) {
        self.topArr = [[NSMutableArray alloc]init];
    }

    if (self.dataArray.count==1) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0 ,self.view.bounds.size.width, kScreenSize.width*50/51)];
        self.tableView.tableHeaderView = self.scrollView;
    
    for (int i = 0; i<model.top_stories.count; i++) {
        NSDictionary * dict = model.top_stories[i];
        Top_storiesModel * model = [[Top_storiesModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(w*i, 0, w, h);
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empty"]];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 101+i;
        [self.scrollView addSubview:button];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, h-w/6-10, w-10, w/6 )];
        titleLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = model.title;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.topArr addObject:model];
        [button addSubview:titleLabel];
    }
    self.scrollView.contentSize = CGSizeMake(model.top_stories.count*w, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    }
    if (self.extraDataArr==nil) {
        self.extraDataArr = [[NSMutableArray alloc]init];
    }
    if (self.extraDataArr) {
        [self.extraDataArr removeAllObjects];
    }
    for (NSDictionary * dict in model.stories) {
    StoryModel * storyModel = [[StoryModel alloc]init];
    [storyModel setValuesForKeysWithDictionary:dict];
        [self.extraDataArr addObject:storyModel];
    }
}
-(void)btnClick:(UIButton *)button{
    NSDictionary * dict = self.latestModel.top_stories[button.tag - 101];
    Top_storiesModel * model = [[Top_storiesModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    StoryDetailViewController * dVC = [[StoryDetailViewController alloc]init];
    dVC.storyId= model.id;
    dVC.myRow = (int)button.tag-101;

    dVC.dataArr =  self.topArr;
    dVC.title =  model.title;
    dVC.type = rootType;
    [self.navigationController pushViewController:dVC animated:YES];
}
//创建下拉刷新和上拉加载
-(void)ceateRefreshView{

    __weak typeof (self) weakSelf = self;//弱引用

    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据

        weakSelf.isRefreshing = YES;//标记正在刷新
        
        NSString *url = nil;
        url = kFirstScrollUrl;
        
        [weakSelf addTaskWithUrl:url isRefresh:YES];
        
    }];

    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        NSString * url =nil;
        url = [NSString stringWithFormat:kFirstPageUrl,weakSelf.currentDate];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
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


//创建tableView
-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = kRowheight;
    
    [self.tableView registerClass:[PicStoryCell class] forCellReuseIdentifier:@"PicStoryCell"];
}

#pragma mark -<UITableViewDataSource,UITableViewDelegate>
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    LatestModel * model = self.dataArray[section];
    return [self transformDateWith: model.date];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 40;
    
}
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString * sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    LatestModel * model = self.dataArray[section];

    sectionTitle = [self transformDateWith: model.date];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kScreenSize.width, 25)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = sectionTitle;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
    view.backgroundColor= myBlue;
    [view addSubview:label];
    return view;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LatestModel * model = self.dataArray[section];
    
    return model.stories.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PicStoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PicStoryCell" forIndexPath:indexPath];
     LatestModel * model = self.dataArray[indexPath.section];
     NSDictionary * dict = model.stories[indexPath.row];
    StoryModel * storyModel = [[StoryModel alloc]init];
    [storyModel setValuesForKeysWithDictionary:dict];
    
        [cell showDataWithModel:storyModel];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryDetailViewController * dVC = [[StoryDetailViewController alloc]init];
    LatestModel * model = self.dataArray[indexPath.section];
    NSDictionary * dict = model.stories[indexPath.row];
    StoryModel * storyModel = [[StoryModel alloc]init];
    [storyModel setValuesForKeysWithDictionary:dict];
    dVC.storyId = storyModel.id;
    dVC.myRow = (int)indexPath.row;
    
    dVC.dataArr  = self.extraDataArr;
    dVC.title =storyModel.title;
    dVC.type = rootType;
    //点击后效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.navigationController pushViewController:dVC animated:YES];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.tabBarController.tabBar.alpha=1-self.tableView.contentOffset.y/(100*self.latestModel.stories.count-200);
    self.navigationController.navigationBar.alpha=1-self.tableView.contentOffset.y/(200+100*self.latestModel.stories.count-200);

    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha=1;
//        self.navigationController.navigationBar.alpha=1;
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha=1;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}






@end
