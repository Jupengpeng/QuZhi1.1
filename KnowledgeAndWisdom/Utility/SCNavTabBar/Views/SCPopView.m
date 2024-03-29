//
//  SCPopView.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCPopView.h"
#import "CommonMacro.h"

@implementation SCPopView

#pragma mark - Private Methods
#pragma mark -
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        [widths addObject:width];
    }
    
    return widths;
}

- (void)updateSubViewsWithItemWidths:(NSArray *)itemWidths;
{
    CGFloat buttonY = DOT_COORDINATE;
    CGFloat padding = kScreenSize.width/16;
    for (NSInteger index = 0; index < [itemWidths count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake((kScreenSize.width/4+padding)*(index/4) +padding, buttonY+ITEM_HEIGHT*(index%4), kScreenSize.width/4, kScreenSize.width/10);
        [button setTitle:_itemNames[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor  = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius =5;
        [self addSubview:button];
        }
}

- (void)itemPressed:(UIButton *)button
{
    [_delegate itemPressedWithIndex:button.tag];
}

#pragma mark - Public Methods
- (void)setItemNames:(NSArray *)itemNames
{
    _itemNames = itemNames;
    
    NSArray *itemWidths = [self getButtonsWidthWithTitles:itemNames];
    [self updateSubViewsWithItemWidths:itemWidths];
}

@end


