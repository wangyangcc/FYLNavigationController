//
//  FYLNavigationBar.h
//  Sidebar-Master
//
//  Created by wang yangyang on 14-5-6.
//  Copyright (c) 2014年 wang yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Ios6Before  floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0
#define Ios7After floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1

static float shadowViewMinAlpha = 0.2; //shadowView 最低的透明度

/**
 *   @brief 为了兼容 Ios5 和 ios7 的 UINavigationBar 显示效果
 *
 **/
@interface FYLNavigationBar : UINavigationBar

@end
