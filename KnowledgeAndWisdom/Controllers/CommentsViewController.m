//
//  CommentsViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-11.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "CommentsViewController.h"
#import "AFNetworking.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "SVProgressHUD.h"
@interface CommentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _longArray;
    NSMutableArray * _shortArray;
    AFHTTPRequestOperationManager * _manager;
}
@property (nonatomic,strong) NSMutableArray * longArray;
@property (nonatomic,strong) NSMutableArray * shortArray;
@property (nonatomic,strong) UITableView * tableView;
#define cellId @"CommentCell"
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.longArray==nil) {
        self.longArray = [[NSMutableArray alloc]init];
    }
    if (self.shortArray==nil) {
        self.shortArray = [[NSMutableArray alloc]init];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initUI];
}

- (void)initData{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString * longUrl = [NSString stringWithFormat:kLongCommentsUrl,self.commentId];
    NSString * shortUrl = [NSString stringWithFormat:kShotCommentsUrl,self.commentId];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager GET:longUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            [SVProgressHUD dismiss];

           NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * arr = dict[@"comments"];
            for (NSDictionary * dict in arr) {
                CommentModel * model = [[CommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.longArray addObject:model];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [_manager GET:shortUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {

            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray * arr = dict[@"comments"];
            for (NSDictionary * dict in arr) {
                CommentModel * model = [[CommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.shortArray addObject:model];
            }
            
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

//        NSLog(@"error %@",[error description]);
    }];

}

- (void)initUI{
    UIView * topView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [self viewShowShadow:topView shadowRadius:10.0f shadowOpacity:10.0f];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreenSize.width, kScreenSize.height-20- kScreenSize.width/8.0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:cellId];
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenSize.height- kScreenSize.width/8.0, kScreenSize.width, kScreenSize.width/8.0)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth =0.5;
    [self.view addSubview:view];
    
    CGFloat padding = kScreenSize.width/160.0;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(padding,0, kScreenSize.width*3/16.0, kScreenSize.width/8.0)];
    [button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

-(void)buttonClick:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark - <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return self.longArray.count;

    }else{

        return self.shortArray.count;

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kScreenSize.width*4/15.0 +30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {

    return [NSString stringWithFormat:@"%lu条长评",self.longArray.count];
    }else{
        return [NSString stringWithFormat:@"%lu条短评",self.shortArray.count];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    CommentModel * model = [[CommentModel alloc]init];
    if (indexPath.section==0) {
        model= self.longArray[indexPath.row];
    }else{
        model = self.shortArray[indexPath.row];
        
    }
    [cell showDataWithCommentModel:model];

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}




@end
