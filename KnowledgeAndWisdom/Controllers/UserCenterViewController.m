//
//  UserCenterViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-1.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "UserCenterViewController.h"
#import "CollectArticleViewController.h"
#import "SavePicViewController.h"
#import "AbouUsViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UMSocial.h"
#import "AbouUsViewController.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * controllerArr;

@end



@implementation UserCenterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initData];
    [self createTableView];
    
}
- (void)initData{
    if (self.dataArr==nil) {

    self.dataArr = [[NSMutableArray alloc]initWithObjects:@"已收藏的文章",@"已保存的图片",@"清除缓存",@"推荐给好友",@"关于我们", nil];
    }
    

}
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        case 2:
            return 2;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return kScreenSize.width/8.0;
    }
    return kScreenSize.width/20;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kScreenSize.width/10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    UITableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = self.dataArr[0];

        }else{
            cell.textLabel.text = self.dataArr[1];

        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text = self.dataArr[2];

        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            cell.textLabel.text = self.dataArr[3];

        }else{
            cell.textLabel.text = self.dataArr[4];

        }
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后效果消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            CollectArticleViewController * view1 = [[CollectArticleViewController alloc]init];
            view1.title = self.dataArr[0];
            [self.navigationController pushViewController:view1 animated:YES];
        }else{
            SavePicViewController * view2 = [[SavePicViewController alloc]init];
            view2.title = self.dataArr[1];
            [self.navigationController pushViewController:view2 animated:YES];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            NSString * title = [NSString stringWithFormat:@"清除缓存文件%.2fMB",[self getCacheSize]];
            UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
            [sheet showInView:self.view];
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            
            NSString *text = @"将要分享本软件";
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"559fcc7c67e58eb98a000d43"
                                              shareText:text
                                             shareImage:[UIImage imageNamed: @"Icon"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToEmail]
                                               delegate:self];
        }else{

            AbouUsViewController * abv = [[AbouUsViewController alloc]init];
            [self.navigationController pushViewController:abv animated:YES];
        }
    }
}
//Actionsheet协议方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
        [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
    }
    
}
//获取缓存大小
- (double)getCacheSize{
    double sdSize = [[SDImageCache sharedImageCache]getSize];
    NSString * myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
    NSDirectoryEnumerator * enumerator = [[NSFileManager defaultManager]enumeratorAtPath:myCachePath];
    double mySize =  0 ;
    for (NSString * fileName  in enumerator) {
        NSString * filePath = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        mySize += dict.fileSize;
    }
    double totalSize = (mySize + sdSize)/1024/1024;
    return totalSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}




@end
