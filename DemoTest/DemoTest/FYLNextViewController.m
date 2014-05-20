//
//  FYLNextViewController.m
//  Sidebar-Master
//
//  Created by wang yangyang on 14-5-8.
//  Copyright (c) 2014年 wang yangyang. All rights reserved.
//

#import "FYLNextViewController.h"
#import "FYLNavigationBar.h"
#import "FYLMiddleVC.h"
#import "FYLCommentVC.h"

@interface FYLNextViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet FYLNavigationBar *bar;

@end

@implementation FYLNextViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    _scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [_scrollView setContentSize:CGSizeMake(320, 700)];
    

    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setTitle:@"返回" forState:UIControlStateNormal];
    left.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 60, 44);
    [left addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    self.bar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.scrollNextVC = [[FYLCommentVC alloc] init];
    
    [self logOnDealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
