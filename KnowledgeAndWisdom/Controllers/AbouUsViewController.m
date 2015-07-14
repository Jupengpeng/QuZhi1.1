//
//  AbouUsViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-10.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "AbouUsViewController.h"

@interface AbouUsViewController ()
{
    BOOL _isTaped;
}

@end

@implementation AbouUsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _isTaped=NO;
    
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BgImage"]];
    imageView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [self.view  addSubview:imageView];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40, kScreenSize.height-kScreenSize.width/7 - 30, kScreenSize.width-80, kScreenSize.width/7)];
    UIColor *color =[[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    button.layer.cornerRadius = 10;
    [button setBackgroundImage:theImage forState:UIControlStateHighlighted] ;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UISwipeGestureRecognizer * swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pop:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
}
- (void)btnClick:(UIButton *)button{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://1670452415@qq.com"]];

}

- (void)pop:(UISwipeGestureRecognizer*)swipe{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
