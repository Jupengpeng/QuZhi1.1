//
//  Topbar.m
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import "Topbar.h"

@interface Topbar ()

@property (nonatomic, retain) UIView *markView;
@property (nonatomic, retain) NSMutableArray *buttons;
@end

@implementation Topbar
{
    CGFloat originX;

}
- (void)dealloc
{
    self.markView =nil;
    self.buttons = nil;
    [super dealloc];
}
- (void)setTitles:(NSMutableArray *)titles {
    self.showsHorizontalScrollIndicator = NO;
    _titles = titles;
    self.buttons = [NSMutableArray array];
    CGFloat padding = 30.0;
    
    // CGSize contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    for (int i = 0; i < titles.count; i++) {
        if ([_titles[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        // buttons
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
        // set button frame
//        static CGFloat originX = 0;
     
        CGRect frame = CGRectMake(originX+padding, 0, button.intrinsicContentSize.width, kTopbarHeight);
     
        button.frame = frame;
        originX      = CGRectGetMaxX(frame) + padding; //originX + padding + button.intrinsicContentSize.width;
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    self.contentSize = CGSizeMake(CGRectGetMaxX([self.buttons.lastObject frame]) + padding, self.frame.size.height);

    // mark view
    UIButton *firstButton = self.buttons.firstObject;
    CGRect frame = firstButton.frame;
    self.markView = [[[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame)-3, frame.size.width, 3)] autorelease];
    _markView.backgroundColor = [UIColor redColor];
    [self addSubview:_markView];
}



- (void)buttonClick:(id)sender {
    self.currentPage = [self.buttons indexOfObject:sender];
    if (_blockHandler) {
        _blockHandler(_currentPage);
    }
}

// overwrite setter of property: selectedIndex
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    UIButton *button = [_buttons objectAtIndex:_currentPage];
    CGRect frame = button.frame;
    frame.origin.x -= 5;
    frame.size.width += 10;
    [self scrollRectToVisible:frame animated:YES];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame)-3, button.frame.size.width, 3);
    } completion:nil];
}

@end
