//
//  FYLMiddleVC.m
//  Sidebar-Master
//
//  Created by wang yangyang on 14-4-25.
//  Copyright (c) 2014年 wang yangyang. All rights reserved.
//

#import "FYLMiddleVC.h"
#import "FYLNavigationBar.h"
#import "FYLNextViewController.h"

@interface FYLMiddleVC ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet FYLNavigationBar *bar;

@end

@implementation FYLMiddleVC

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

   // self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    self.view.backgroundColor = [UIColor blackColor];
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    _scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [_scrollView setContentSize:CGSizeMake(320, 788)];
    
    self.isRemovePanGestureBlack = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
    [_scrollView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next
{
//    [(FYLNavigationController *)self.navigationController pushController:[FYLNextViewController new]];
    [self.navigationController pushViewController:[FYLNextViewController new] animated:YES];
}

@end
