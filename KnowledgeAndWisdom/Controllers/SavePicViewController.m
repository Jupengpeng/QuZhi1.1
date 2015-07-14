//
//  SavePicViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-9.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "SavePicViewController.h"
#import "DBmanager.h"
#import "CollectPicCell.h"
#import "PictureDetailViewController.h"
#define CellId @"CollectPicCell"
@interface SavePicViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UICollectionView * collectionView;

@end

@implementation SavePicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"用户" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    
    
    if (self.dataArray==nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    self.view.backgroundColor = [UIColor whiteColor];
  NSArray * arr=  [[DBmanager sharedManager] readPicModels];
    [self.dataArray addObjectsFromArray:arr];

    [self createCollection];
}


- (void)btnClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)createCollection{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
   [ self.collectionView registerClass:[CollectPicCell class] forCellWithReuseIdentifier:CellId];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegat>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectPicCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];

    
    cell.layer.borderWidth = 2.0f;
    cell.layer.borderColor = myBlue.CGColor;
    PicDetailModel * model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model];

    
    
    if (cell.deleteButton==nil) {
        cell.deleteButton = [[MyButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.titleLabel.frame), CGRectGetMaxY(cell.smallImagView.frame), (kScreenSize.width-40)/6, (kScreenSize.width-40)/10)];
        cell.deleteButton.backgroundColor = [UIColor whiteColor];
        [cell.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [cell.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.deleteButton.titleLabel.adjustsFontSizeToFitWidth=YES;
        cell.deleteButton.backgroundColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1];
        [cell.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag =model.id.intValue;
        [cell addSubview:cell.deleteButton];
    }

    
    cell.deleteButton.myIndex = indexPath.row;

    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kScreenSize.width-40)/2, (kScreenSize.width-40)*7/10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PictureDetailViewController * pvc = [[PictureDetailViewController alloc]init];
    pvc.dataArr = self.dataArray;
    pvc.savedIndex = indexPath.row;
    [self.navigationController pushViewController:pvc animated:YES];
}

    - (void)delete:(MyButton *)button{
        [[DBmanager sharedManager]deleteModelForPicId:[ NSString stringWithFormat:@"%ld",(long)button.tag]];
        [self.dataArray removeObjectAtIndex:button.myIndex];
        [self.collectionView reloadData];
        
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}




@end
