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

#define shadowMin   0.2
#define shadowMax   0.7

#define PushPopTime  0.35

#define SelfView_H CGRectGetHeight(self.view.frame)

#define SelfView_W CGRectGetWidth(self.view.frame)

@interface FYLNavigationController () {

    UIView *shadowView;
    
    BOOL isAleft;
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
    _interactivePopGestureRecognizerA.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:_interactivePopGestureRecognizerA];
    self.interactivePopGestureRecognizer = _interactivePopGestureRecognizerA;
    
    self.delegate = self;
}

- (void)dealloc
{
    self.delegate = nil;
    shadowView = nil;
    self.interactivePopGestureRecognizer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [self addShadowView:viewController defaultValue:0.0f];
    
    [UIView animateWithDuration:PushPopTime
                     animations:^{
                         shadowView.alpha = shadowMax;
                     }];

   [super pushViewController:viewController animated:YES];
    
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    [self addShadowView:self.topViewController defaultValue:shadowMax];
    
    [UIView animateWithDuration:PushPopTime
                     animations:^{
                         shadowView.alpha = 0.0;
                     }];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{

    [self addShadowView:self.topViewController defaultValue:shadowMax];
    [UIView animateWithDuration:PushPopTime
                     animations:^{
                         shadowView.alpha = 0.0;
                     }];
    self.interactivePopGestureRecognizer.enabled = NO;
    return [super popToRootViewControllerAnimated:(BOOL)animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addShadowView:self.topViewController defaultValue:shadowMax];
    [UIView animateWithDuration:PushPopTime
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
    rect.origin.x = 0;
    rect.origin.x -= SelfView_W;
    rect.size.width = SelfView_W;
    rect.size.height = SelfView_H;
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
    //velocityX 为正时候向右滑动，为负时候向左滑动
    CGFloat velocityX = [gestureRecognizer velocityInView:self.view].x;
    
    //如果是向左滑动
    if (isAleft) {
        [self aleftPanGestureRecognizer:gestureRecognizer
                                translationX:translationX velocityX:velocityX];
    }
    else {
        [self rightwardsPanGestureRecognizer:gestureRecognizer
                                translationX:translationX velocityX:velocityX];
    }
}

- (void)aleftPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
                     translationX:(CGFloat)translationX
                        velocityX:(CGFloat)velocityX
{
    UIViewController *currentViewController = self.visibleViewController;
    if (currentViewController.scrollNextVC == nil) {
        return;
    }
    UIViewController *nextViewController = currentViewController.scrollNextVC;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *navView = [[self.view subviews] firstObject];
        UIView *controllerView = [[navView subviews] firstObject];
        nextViewController.view.frame = controllerView.bounds;
        if (![nextViewController.view isDescendantOfView:controllerView]) {
            [controllerView insertSubview:nextViewController.view aboveSubview:currentViewController.view];
            //中间的视图添加阴影
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:nextViewController.view.bounds];
            nextViewController.view.layer.shadowPath = path.CGPath;
            [nextViewController.view layer].shadowColor = [UIColor blackColor].CGColor;
            [nextViewController.view layer].shadowOffset = CGSizeMake(3, 0);
            [nextViewController.view layer].shadowOpacity = 0.7;
            [nextViewController.view layer].shadowRadius = 3.0;
            //添加阴影view
            [self addShadowView:nextViewController defaultValue:0.0f];
        }
        nextViewController.view.center = CGPointMake(3*SelfView_W/2, CGRectGetHeight(nextViewController.view.frame)/2);
        currentViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(currentViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat inViewCenterX = 3*SelfView_W/2 + translationX;
        CGFloat outViewCenterX = SelfView_W/2 + translationX/(SelfView_W/98.0);
        if (inViewCenterX < SelfView_W/2) {
            inViewCenterX = SelfView_W/2;
        }
        if (outViewCenterX > SelfView_W/2) {
            outViewCenterX = SelfView_W/2;
        }
        
        float shadowX = shadowMax - shadowMax *(98 + translationX/(SelfView_W/98.0))/98;
        shadowView.alpha = shadowX;
        nextViewController.view.center = CGPointMake(inViewCenterX, CGRectGetHeight(nextViewController.view.frame)/2);
        currentViewController.view.center = CGPointMake(outViewCenterX, CGRectGetHeight(currentViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {

        if (translationX > - 270) {
            if (velocityX > 0) {
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    shadowView.alpha = 0.0f;
                    nextViewController.view.center = CGPointMake(3*SelfView_W/2, CGRectGetHeight(nextViewController.view.frame)/2);
                    currentViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(currentViewController.view.frame)/2);
                } completion:^(BOOL finished) {
                    [nextViewController.view removeFromSuperview];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }];
                
                return;
            }
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            shadowView.alpha = shadowMax;
            nextViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(nextViewController.view.frame)/2);
            currentViewController.view.center = CGPointMake(62, CGRectGetHeight(currentViewController.view.frame)/2);
        } completion:^(BOOL finished) {
            
            [nextViewController beginAppearanceTransition:YES animated:YES];
            
            [currentViewController willMoveToParentViewController:nil];
            [currentViewController beginAppearanceTransition:NO animated:YES];
            
            [currentViewController.view removeFromSuperview];
            [currentViewController endAppearanceTransition];
            
            NSMutableArray *viewCon = [self.viewControllers mutableCopy];
            [viewCon addObject:nextViewController];
            [self setViewControllers:viewCon animated:NO];
            [nextViewController endAppearanceTransition];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];

    }
}

- (void)rightwardsPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
                          translationX:(CGFloat)translationX
                             velocityX:(CGFloat)velocityX
{
    UIViewController * outViewController = [self.viewControllers lastObject];
    
    UIViewController * inViewController = self.viewControllers[([self.viewControllers count] - 2)];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        UIView *navView = [[self.view subviews] firstObject];
        //NSLog(@"%@",[navView subviews]);
        UIView *controllerView = [[navView subviews] firstObject];
        inViewController.view.frame = controllerView.bounds;
        if ([[controllerView subviews] count] < 2) {
            [controllerView insertSubview:inViewController.view belowSubview:outViewController.view];
            //中间的视图添加阴影
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:outViewController.view.bounds];
            outViewController.view.layer.shadowPath = path.CGPath;
            [outViewController.view layer].shadowColor = [UIColor blackColor].CGColor;
            [outViewController.view layer].shadowOffset = CGSizeMake(3, 0);
            [outViewController.view layer].shadowOpacity = 0.7;
            [outViewController.view layer].shadowRadius = 3.0;
            //添加阴影view
            [self addShadowView:self.topViewController defaultValue:shadowMax];
        }
        inViewController.view.center = CGPointMake(62, CGRectGetHeight(inViewController.view.frame)/2);
        outViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(outViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat inViewCenterX = 62.0 + translationX/(SelfView_W/98.0);
        CGFloat outViewCenterX = SelfView_W/2 + translationX;
        if (inViewCenterX > SelfView_W/2) {
            inViewCenterX = SelfView_W/2;
        }
        if (outViewCenterX < SelfView_W/2) {
            outViewCenterX = SelfView_W/2;
        }
        float shadowX = shadowMax *(80 - translationX/(SelfView_W/98.0))/80;
        shadowView.alpha = shadowX;
        inViewController.view.center = CGPointMake(inViewCenterX, CGRectGetHeight(inViewController.view.frame)/2);
        outViewController.view.center = CGPointMake(outViewCenterX, CGRectGetHeight(outViewController.view.frame)/2);
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (translationX < 230) {
            if (velocityX < 170) {
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    shadowView.alpha = shadowMax;
                    outViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(outViewController.view.frame)/2);
                    inViewController.view.center = CGPointMake(62, CGRectGetHeight(inViewController.view.frame)/2);
                } completion:^(BOOL finished) {
                    //inViewController.view.hidden = YES;
                    [inViewController.view removeFromSuperview];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }];
                
                return;
            }
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            shadowView.alpha = 0.0f;
            inViewController.view.center = CGPointMake(SelfView_W/2, CGRectGetHeight(inViewController.view.frame)/2);
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        CGFloat velocityX = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view].x;
        isAleft = velocityX <= 0;
    }
    return YES;
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
static char scrollNextVCKey;

@implementation UIViewController (FYNavigationController)
@dynamic isRemovePanGestureBlack;
@dynamic scrollNextVC;

- (BOOL)isRemovePanGestureBlack
{
    return [objc_getAssociatedObject(self, &RemovePanGestureBlackKey) boolValue];
}

- (void)setIsRemovePanGestureBlack:(BOOL)isRemovePanGestureBlack
{
    objc_setAssociatedObject(self, &RemovePanGestureBlackKey, [NSNumber numberWithBool:isRemovePanGestureBlack], OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)scrollNextVC
{
    return objc_getAssociatedObject(self, &scrollNextVCKey);
}

- (void)setScrollNextVC:(UIViewController *)scrollNextVC
{
    objc_setAssociatedObject(self, &scrollNextVCKey, scrollNextVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addDefaultNavigationBar:(UIRectEdge)f_rectEdge
        AdjustsScrollViewInsets:(BOOL)b
{
//    FYLNavigationBar *bar = nil;
//    if (Ios7After) {
//        bar = [[FYLNavigationBar alloc] initWithFrame:CGRectMake(0, 20, SelfView_W, 44)];
//    }
//    else {
//        bar = [[FYLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SelfView_W, 44)];
//    }
    
    
}

@end