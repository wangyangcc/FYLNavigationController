//
//  FYNavigationController.h
//  XiangYou-Master
//
//  Created by wang yangyang on 13-12-17.
//  Copyright (c) 2013年 wang yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef __IPHONE_7_0
typedef NS_OPTIONS(NSUInteger, UIRectEdge) { //  让 xocde4 能编译过
    UIRectEdgeNone   = 0,
    UIRectEdgeTop    = 1 << 0,
    UIRectEdgeLeft   = 1 << 1,
    UIRectEdgeBottom = 1 << 2,
    UIRectEdgeRight  = 1 << 3,
    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
};
#endif

//ios7 之前 默认从20像素开始，ios 7 之后，从0像素开始

@interface FYLNavigationController : UINavigationController <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

+ (void)setDefaultNavigationBarProperty;

@end

@interface UIViewController (FYNavigationController)

@property (nonatomic, assign) BOOL isRemovePanGestureBlack; //是否移除 pan 滑动返回功能

@property (nonatomic, strong) UIViewController *scrollNextVC; //添加下个滑动显示的 viewController

- (void)addDefaultNavigationBar:(UIRectEdge)f_rectEdge
        AdjustsScrollViewInsets:(BOOL)b;

@end
