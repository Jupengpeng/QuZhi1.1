//
//  PicturesViewControllersViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-6.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "PicturesViewController.h"
#import "SVProgressHUD.h"
@interface PicturesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * _dataArr;
    UITableView * _tableView;
    AFHTTPRequestOperationManager * _manager;
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadMore;
@end

@implementation PicturesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
    [self.tabBarController.tabBar setHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets= YES;
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.dataArr==nil) {
        self.dataArr = [[NSMutableArray alloc]init];
    }
    self.currentPage=1;
    [self initUI];
    [self firstDownload];
    [self ceateRefreshView];
    
}
- (void)firstDownload{
    
    NSString * url = [NSString stringWithFormat:kPicHomeUrl,@"1"];
    [self addTaskWithUrl:url refresh:NO];
    
}
- (void)addTaskWithUrl:(NSString *)url refresh:(BOOL)isRefreshing{
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
        PictureHomeModel * model = [[PictureHomeModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
            for (int i = 0; i < model.album.count; i++) {
                NSDictionary * albumDict = model.album[i];
            AlbumModel * albumModel = [[AlbumModel alloc]init];
            [albumModel setValuesForKeysWithDictionary:albumDict];
            [weakSelf.dataArr addObject:albumModel];
        }
            [weakSelf.tableView reloadData];
        }
        [weakSelf endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;


    }];
    
    
}
- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height+5) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[AlbumCell class] forCellReuseIdentifier:@"AlbumCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

//创建下拉刷新和上拉加载
-(void)ceateRefreshView{
    
    __weak typeof (self) weakSelf = self;//弱引用
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        
        weakSelf.isRefreshing = YES;//标记正在刷新
        
        NSString *url = nil;
        url = [NSString stringWithFormat:kPicHomeUrl,@"1"];
        
        
        [weakSelf addTaskWithUrl:url refresh:YES];
        
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.currentPage++;
        weakSelf.isLoadMore = YES;
        NSString * url =nil;
        url = [NSString stringWithFormat:kPicHomeUrl,[NSString stringWithFormat:@"%lu" ,weakSelf.currentPage]];
        [weakSelf addTaskWithUrl:url refresh:YES];
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


#pragma  mark - <UITableViewDataSource,UITableViewDelegate>
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenSize.width*19/24.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    AlbumModel * model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PictureDetailViewController * pvc = [[PictureDetailViewController alloc]init];
    AlbumModel * model = self.dataArr[indexPath.row];
    pvc.albumId = model.id;
    //点击后效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.navigationController pushViewController:pvc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//自动隐藏
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
