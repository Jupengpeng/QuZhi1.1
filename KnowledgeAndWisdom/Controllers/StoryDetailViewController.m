//
//  DetailViewController.m
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-6.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "UMSocial.h"
#import "CommentsViewController.h"
@interface StoryDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,copy) NSString * webUrl;

@end

@implementation StoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"加载中" ];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self createWebView];
    [self addMyBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:YES];
    
}
-(void)createWebView{
    self.webUrl = [NSString stringWithFormat:kWebViewUrl,self.storyId];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,20 , kScreenSize.width, kScreenSize.height*8/9.0)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    [self.webView loadRequest:request];

    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
}
- (void)addMyBar{
    UIView * topView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [self viewShowShadow:topView shadowRadius:10.0f shadowOpacity:10.0f];
    
    
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenSize.height- kScreenSize.width/8.0, kScreenSize.width, kScreenSize.width/8.0)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth =0.5;
    
    [self.view addSubview:view];
    for (int i= 0 ; i<5; i++) {
    CGFloat padding = kScreenSize.width/160.0;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(padding+i*(2*padding+kScreenSize.width*3/16.0),0, kScreenSize.width*3/16.0, kScreenSize.width/8.0)];

        
        
        switch (i) {
            case 0:
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
                break;
            case 1:
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Next"] forState:UIControlStateNormal];
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Next_Highlight"] forState:UIControlStateHighlighted];
                break;
            case 2:{
                NSArray * arr =  [[DBmanager sharedManager] readArticleModelsWithTitle:self.title];
                if (arr.count) {
                    self.button.selected = YES;
                }
                [self.button setBackgroundImage:[UIImage imageNamed:@"Fav_Normal"] forState:UIControlStateNormal];

                [self.button setBackgroundImage:[UIImage imageNamed:@"Fav_Selected"] forState:UIControlStateSelected];
                [self.button setShowsTouchWhenHighlighted:YES];

            }
                break;
            case 3:
                self.button.selected = NO;

                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Share"] forState:UIControlStateNormal];
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Share_Highlight"] forState:UIControlStateHighlighted];
                break;
            case 4:
                self.button.selected = NO;

                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Comment"] forState:UIControlStateNormal];
                [self.button setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Comment_Highlight"] forState:UIControlStateHighlighted];
                break;
            default:
                break;
        }
        self.button.tag = 201+i;
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.button];
    }
}


-(void)buttonClick:(UIButton *)button{
    long tag = button.tag - 201;
    int currentRow = self.myRow;
    switch (tag) {
        case 0:
            if ([self.type isEqualToString: rootType]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
            break;
        case 1:
        {
            if (self.myRow ==self.dataArr.count-1) {

                [SVProgressHUD showInfoWithStatus: @"当前列表到底了~"];
                if ([self.type isEqualToString: rootType]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }
                return;
            }
            StoryDetailViewController * dvc=  [[StoryDetailViewController alloc]init];
            currentRow ++;
            StoryModel * model = self.dataArr[currentRow];
            dvc.storyId = model.id;
            dvc.dataArr = self.dataArr;
            dvc.myRow = currentRow;
            dvc.title = model.title;
            dvc.type = self.type;
            [UIView  beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            [self.navigationController pushViewController:dvc animated:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];

        }
            break;
        case 2:{

            if ( button.selected == YES) {
                [[DBmanager sharedManager] deleteModelForStoryId:self.storyId];
                if (_myBlock) {
                    _myBlock(self.storyId);
                }
                
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"已取消收藏"];
                button.selected = NO;
                return;
            }
            
            button.selected = NO;
            DetailModel * model = [[DetailModel alloc]init];
            model.share_url = self.webUrl;
            model.title= self.title;
            model.id = self.storyId;
            [[DBmanager sharedManager] insertModel:model ];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"已收藏"];
            button.selected=YES;
        }break;
        case 3:
        {
            NSString *text = [NSString stringWithFormat:@"将要分享文章“%@”",self.title];
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"559fcc7c67e58eb98a000d43"
                                              shareText:text
                                             shareImage:[UIImage imageNamed: @"Icon"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,UMShareToEmail]
                                               delegate:self];
            
        }break;
        case 4:{
            CommentsViewController * cvc = [[CommentsViewController alloc]init];
            cvc.commentId = self.storyId;
            [self.navigationController pushViewController:cvc animated:YES];
        }

            break;
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
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark -<UIWebViewDelegate>
-(BOOL )webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType )navigationType{
    
    return YES;
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//网页加载完成的时候调用
- (void )webViewDidFinishLoad:(UIWebView *)webView{


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getRefreshAction:(RefreshCollectBLock)myBlock{
    if (_myBlock!= myBlock) {
        _myBlock = [myBlock copy];
    }
    
}
@end