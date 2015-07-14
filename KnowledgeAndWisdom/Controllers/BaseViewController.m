//
//  BaseViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-1.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = myBlue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (NSString *)transformDateWith:(NSString*)date{
    NSString * y = nil;
    NSString * m = nil;
    NSString * d = nil;
    y = [date substringToIndex:4];
    m =[date substringWithRange:NSMakeRange(4, 2)];
    d = [date substringWithRange:NSMakeRange(6, 2)];
    
    
    return [NSString stringWithFormat:@"%@年%@月%@日",y,m,d];
    
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}
@end
