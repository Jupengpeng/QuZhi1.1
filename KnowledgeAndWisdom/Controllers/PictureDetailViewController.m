//
//  PictureDetailViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-7.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "DBmanager.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
@interface PictureDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UMSocialUIDelegate>
{
    UIScrollView * _scrollView;
    AFHTTPRequestOperationManager * _manager;
    NSMutableArray * _dataArr;
    
    
    
    UITextView * _textView;
    UILabel * _titleLabel;
    UIView * _bottomView;
}
@property (nonatomic,strong) UITextView * textView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * bottomView;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) PicDetailModel * picDetailModel;

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UICollectionView * collectionView;

#define cellId @"AlbumDetailCell"
@end

@implementation PictureDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.savedIndex==0) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.savedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets =NO;
    if (self.dataArr==nil) {
        self.dataArr = [[NSMutableArray alloc]init];
    }
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self initData];
    [self initUI];
}
- (void)initData{
    if (self.albumId==nil) {
        return;
    }
    NSString * url = [NSString stringWithFormat:kPicDetailUrl,self.albumId];
    __weak typeof (self) weakSelf = self;

    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            PicSecPageModel * secModel = [[PicSecPageModel alloc]init];
            [secModel setValuesForKeysWithDictionary:dict];
            for (NSDictionary * detailDict in secModel.picture) {
                PicDetailModel * detailModel = [[PicDetailModel alloc]init];
                [detailModel setValuesForKeysWithDictionary:detailDict];
                [weakSelf.dataArr addObject:detailModel];
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
    }];

}

- (void)initUI{
    UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[AlbumDetailCell class] forCellWithReuseIdentifier:cellId];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]init];
    tap1.numberOfTapsRequired  = 1;
    [tap1 addTarget:self action:@selector(tap1:)];
    [self.view addGestureRecognizer:tap1];

}
//界面点击一次触发
- (void)tap1:(UITapGestureRecognizer *)tap{
    self.textView.hidden = !self.textView.hidden;
    self.titleLabel.hidden = !self.titleLabel.hidden;
    self.bottomView.hidden = !self.bottomView.hidden;
    
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    if (self.titleLabel==nil) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,kScreenSize.height-kScreenSize.width*7/16.0-6 , kScreenSize.width, kScreenSize.width/16.0)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
        [self.view addSubview:self.titleLabel];
    }
    if (self.textView==nil) {
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+3, kScreenSize.width, kScreenSize.width/4)];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.font = [UIFont systemFontOfSize:16.0];
        self.textView.editable = NO;
        self.textView.textColor = [UIColor whiteColor];
                [self.view addSubview:self.textView];
    }
    
    
    
    //底边栏
    if (self.bottomView==nil) {
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.textView.frame)+3, kScreenSize.width, kScreenSize.width/8.0)];
        [ self.bottomView  setBackgroundColor:[UIColor clearColor]];
        self.bottomView .layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.bottomView .layer.borderWidth =0.1;
        
        [self.view addSubview: self.bottomView ];
        for (int i= 0 ; i<3; i++) {
            CGFloat padding = 3;
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(padding+i*(2*padding+(kScreenSize.width-18)/3), kScreenSize.width/48.0, (kScreenSize.width-18)/3, kScreenSize.width/12.0)];
            button.backgroundColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.1];;
            switch (i) {
                case 0:
                    [button setTitle:@"返回" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                    break;
                case 1:
                    [button setTitle:@"保存" forState:UIControlStateNormal];
                    
                    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

                    break;
                case 2:

                    [button setTitle:@"分享" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];


                default:
                    break;
            }
            button.tag = 201+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [ self.bottomView  addSubview:button];
        }
    }

    self.picDetailModel = self.dataArr[indexPath.row];

    [cell showDataWithModel:self.picDetailModel];
    if (indexPath.row!=self.dataArr.count-1) {
    self.textView.text = [NSString stringWithFormat:@"%@（摄影：%@）", self.picDetailModel.content,self.picDetailModel.author];
    }else{
            self.textView.text = self.picDetailModel.content;
        
    }
    self.titleLabel.text = self.picDetailModel.title;

    return cell;
    
    
}

//下底栏3个按钮功能

-(void)buttonClick:(UIButton *)button{
    long tag = button.tag - 201;
    switch (tag) {
        case 0:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        case 1:
        {
                [[DBmanager sharedManager] insertPicModel:self.picDetailModel ];
            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];

            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"已保存"];

        }
            break;
        case 2:
        {
            
            
            NSString *text = [NSString stringWithFormat:@"将要分享图片“%@”",self.picDetailModel.title];
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"559fcc7c67e58eb98a000d43"
                                              shareText:text
                                             shareImage:[UIImage imageNamed: @"Icon"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToEmail]
                                               delegate:self];
        }break;
        default:
            break;
    }
    
    
}
#pragma mark - <UMSocialDataDelegate>

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
