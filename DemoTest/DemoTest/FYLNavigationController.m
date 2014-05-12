//
//  FYNavigationController.m
//  XiangYou-Master
//
//  Created by wang yangyang on 13-12-17.
//  Copyright (c) 2013年 wang yangyang. All rights reserved.
//

#import "FYLNavigationController.h"
#import <objc/runtime.h>
#import "FYLNavigationBar.h"

#define shadowViewMax   0.7

@interface FYLNavigationController () {

    UIView *shadowView;
}

@property (nonatomic, strong) UIPanGestureRecognizer *interactivePopGestureRecognizer;

@end

@implementation FYLNavigationController
@synthesize interactivePopGestureRecognizer = _interactivePopGestureRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // ios 7 下去掉 左滑返回功能
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.navigationBarHidden = YES;
    
    shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = shadowViewMinAlpha;
    
    
    UIPanGestureRecognizer *_interactivePopGestureRecognizerA = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    _interactivePopGestureRecognizerA.delegate = self;
    [self.view addGestureRecognizer:_interactivePopGestureRecognizerA];
    self.interactivePopGestureRecognizer = _interactivePopGestureRecognizerA;
#if !__has_feature(objc_arc)
    [_interactivePopGestureRecognizerA release];
#endif
    
    self.delegate = self;
}

- (void)dealloc
{
    self.delegate = nil;
    shadowView = nil;
    self.interactivePopGestureRecognizer = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] >= 2) {
        //移除可能存在的在滑动过程中添加的 view
        UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] >= 2) {
            [inViewController.view removeFromSuperview];
        }
    }
    
    [self addShadowView:viewController defaultValue:0.0f];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         shadowView.alpha = 0.7;
                     }];

   [super pushViewController:viewController animated:YES];
    
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    if ([self.viewControllers count] >= 2) {
        UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] >= 2) {
            [inViewController.view removeFromSuperview];
        }
    }

    [self addShadowView:self.topViewController defaultValue:0.7f];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         shadowView.alpha = 0.0;
                     }];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count] >= 2) {
        UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] >= 2) {
            [inViewController.view removeFromSuperview];
        }
    }
    [self addShadowView:self.topViewController defaultValue:0.7f];
    [UIView animateWithDuration:0.35
                     animations:^{
                         shadowView.alpha = 0.0;
                     }];
    self.interactivePopGestureRecognizer.enabled = NO;
    return [super popToRootViewControllerAnimated:(BOOL)animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] >= 2) {
        UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] >= 2) {
            [inViewController.view removeFromSuperview];
        }
    }
    [self addShadowView:self.topViewController defaultValue:0.7f];
    [UIView animateWithDuration:0.35
                     animations:^{
                         shadowView.alpha = 0.0;
                     }];
    self.interactivePopGestureRecognizer.enabled = NO;
    return [super popToViewController:viewController animated:animated];
}

- (void)addShadowView:(UIViewController *)viewConroller
            defaultValue:(float)defaultValue
{
    if (![shadowView isDescendantOfView:viewConroller.view]) {
        [viewConroller.view addSubview:shadowView];
    }
    CGRect rect = shadowView.frame;
    rect.origin.x = -320.0f;
    shadowView.frame = rect;
    shadowView.alpha = defaultValue;
}

#pragma mark - 滑动手势相关

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.visibleViewController.isRemovePanGestureBlack) {
        return;
    }
    CGFloat translationX = [gestureRecognizer translationInView:self.view].x;
    CGFloat velocityX = [gestureRecognizer velocityInView:self.view].x;
    
    UIViewController * outViewController = [self.viewControllers lastObject];
    
    UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] < 2) {
            [controllerView insertSubview:inViewController.view belowSubview:outViewController.view];
            
            //添加阴影view
            [self addShadowView:self.topViewController defaultValue:0.7f];
        }
        inViewController.view.center = CGPointMake(62, CGRectGetHeight(inViewController.view.frame)/2);
        outViewController.view.center = CGPointMake(160, CGRectGetHeight(outViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat inViewCenterX = 62.0 + translationX/(320.0/98.0);
        CGFloat outViewCenterX = 160.0 + translationX;
        if (inViewCenterX > 160) {
            inViewCenterX = 160;
        }
        if (outViewCenterX < 160) {
            outViewCenterX = 160;
        }
        float shadowX = shadowViewMax *(80 - translationX/(320.0/98.0))/80;
        shadowView.alpha = shadowX;
        inViewController.view.center = CGPointMake(inViewCenterX, CGRectGetHeight(inViewController.view.frame)/2);
        outViewController.view.center = CGPointMake(outViewCenterX, CGRectGetHeight(outViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (translationX < 230) {
            if (velocityX < 170) {
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    shadowView.alpha = shadowViewMax;
                    outViewController.view.center = CGPointMake(160, CGRectGetHeight(outViewController.view.frame)/2);
                    inViewController.view.center = CGPointMake(62, CGRectGetHeight(inViewController.view.frame)/2);
                } completion:^(BOOL finished) {
                    //inViewController.view.hidden = YES;
//                    [inViewController.view removeFromSuperview];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }];
                
                return;
            }
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            shadowView.alpha = 0.0f;
            inViewController.view.center = CGPointMake(160, CGRectGetHeight(inViewController.view.frame)/2);
            outViewController.view.center = CGPointMake(CGRectGetWidth(self.view.frame) + 160, CGRectGetHeight(outViewController.view.frame)/2);
        } completion:^(BOOL finished) {
            [inViewController beginAppearanceTransition:YES animated:YES];
            
            [outViewController willMoveToParentViewController:nil];
            [outViewController beginAppearanceTransition:NO animated:YES];
            
            UIViewController * outViewController = [self.viewControllers lastObject];
            [outViewController.view removeFromSuperview];
            [outViewController endAppearanceTransition];
            [outViewController removeFromParentViewController];
            
            UIViewController * inViewController = [self.viewControllers lastObject];
            [inViewController endAppearanceTransition];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [shadowView removeFromSuperview];
    self.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - 屏幕旋转设置 相关

/**
 *   @brief 添加方法 取消旋转
 *
 **/
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

//设置 默认的 navbar 属性 和 statusbar 属性
+ (void)setDefaultNavigationBarProperty
{
    // ios 7
    if (Ios7After) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:91/255.0 green:181/255.0 blue:205/255.0 alpha:1]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:20],NSFontAttributeName,
                                                              nil]];
    }
    else {
        //用来确保状态栏在ios 7 之前背景是黑色的
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        //用来确保 NavigationBar 在ios 7 之前顶部两端是直角的
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor],UITextAttributeTextColor,
                                                              [UIColor clearColor],
                                                              UITextAttributeTextShadowColor,
                                                              [UIFont systemFontOfSize:20.0],
                                                              UITextAttributeFont,
                                                              nil]];
    }
}

@end

static char RemovePanGestureBlackKey;

@implementation UIViewController (FYNavigationController)
@dynamic isRemovePanGestureBlack;

- (BOOL)isRemovePanGestureBlack
{
    return [objc_getAssociatedObject(self, &RemovePanGestureBlackKey) boolValue];
}

- (void)setIsRemovePanGestureBlack:(BOOL)isRemovePanGestureBlack
{
    objc_setAssociatedObject(self, &RemovePanGestureBlackKey, [NSNumber numberWithBool:isRemovePanGestureBlack], OBJC_ASSOCIATION_ASSIGN);
}

- (void)addDefaultNavigationBar:(UIRectEdge)f_rectEdge
        AdjustsScrollViewInsets:(BOOL)b
{
    FYLNavigationBar *bar = nil;
    if (Ios7After) {
        bar = [[FYLNavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    }
    else {
        bar = [[FYLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    
}

@end