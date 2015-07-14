//
//  BaseViewController.h
//  KnowledgeAndWisdom
//
//  Created by qianfeng on 15-7-1.
//  Copyright (c) 2015年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity;
- (NSString *)transformDateWith:(NSString*)date;
@end
