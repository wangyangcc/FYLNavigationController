//
//  FYLNavigationBar.m
//  Sidebar-Master
//
//  Created by wang yangyang on 14-5-6.
//  Copyright (c) 2014年 wang yangyang. All rights reserved.
//

#import "FYLNavigationBar.h"

@interface FYLNavigationBar () {

    BOOL isIos7After;
}

@property (nonatomic,strong)UIImageView *navColorOverly;

@end

@implementation FYLNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self p_init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self p_init];
}

- (void)p_init
{
    
    //self.opaque = NO;
    // ios5 以上
    NSArray *vs = [self subviews];
    Class clazz;
    if (Ios6Before == NO) {
        clazz = NSClassFromString(@"_UINavigationBarBackground");
    }else{
        clazz = NSClassFromString(@"UINavigationBarBackground");
    }
    //隐藏初始的 背景
    for (UIView *v in vs) {
        if ([v isKindOfClass:clazz]) {
            v.hidden = YES;
            break;
        }
    }
    //添加新的背景
    _navColorOverly = [[UIImageView alloc] init];
    if (Ios7After) {
        self.clipsToBounds = NO;
        _navColorOverly.frame = CGRectMake(0, -20, self.frame.size.width, 64);
    }
    else {
        _navColorOverly.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    }
    [self insertSubview:_navColorOverly atIndex:0];
    
    [self setNavBarBgWithColor:[UIColor colorWithRed:91/255.0 green:181/255.0 blue:205/255.0 alpha:1]];
}

- (void)setNavBarBgWithColor:(UIColor *)cl
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [cl set];
    UIRectFill(CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navColorOverly.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

/**
 *   @brief 重写父类的设置背景色方法
 *
 **/
- (void)setBarTintColor:(UIColor *)barTintColor
{
    [super setBarTintColor:barTintColor];
    [self setNavBarBgWithColor:barTintColor];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setNavBarBgWithColor:tintColor];
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}


@end

@implementation UINavigationBar (CustomImage)
//- (void)drawRect:(CGRect)rect {
//
//}
@end
