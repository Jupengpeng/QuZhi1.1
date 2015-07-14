//
//  TabViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-1.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "TabBarViewController.h"
#import "UserCenterViewController.h"
#import "FirstViewController.h"
#import "NewsViewController.h"
#import "ContainerViewController.h"
#import "PicturesViewController.h"

@interface TabBarViewController ()
{
    NSArray *_titleArray;
}
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewControllers];

}
-(void)creatViewControllers{


    
    
    
    _titleArray = [NSArray arrayWithObjects:@"首页",@"知道",@"图志",@"用户", nil];
    
    FirstViewController * firstVC= [[FirstViewController alloc]init];
    UINavigationController * niv1 = [[UINavigationController alloc]initWithRootViewController:firstVC];
    niv1.tabBarItem.image = [UIImage  imageNamed:@"tabbar_icon_news_highlight"];
    niv1.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    niv1.tabBarController.tabBar.barTintColor = myBlue;
    firstVC.title = _titleArray[0];
    UserCenterViewController * userVC = [[UserCenterViewController alloc]init];


    
    
    ContainerViewController * container = [[ContainerViewController alloc]init];
    UINavigationController * niv2 = [[UINavigationController alloc]initWithRootViewController:container];
    niv2.tabBarItem.image = [UIImage  imageNamed:@"tabbar_icon_reader_highlight"];

    container.title = _titleArray[1];
    //图片界面
    PicturesViewController * pVC =[[PicturesViewController alloc]init];
    pVC.title = _titleArray[2];
    UINavigationController * niv3 = [[UINavigationController alloc]initWithRootViewController:pVC];
    niv3.tabBarItem.image = [UIImage  imageNamed:@"tabbar_icon_found_highlight"];

    //用户中心
    UINavigationController * niv4 = [[UINavigationController alloc]initWithRootViewController:userVC];
    niv4.tabBarItem.image = [UIImage  imageNamed:@"tabbar_icon_me_highlight"];

    
    userVC.title = _titleArray[3];
    self.viewControllers =@[niv1,niv2,niv3,niv4];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
