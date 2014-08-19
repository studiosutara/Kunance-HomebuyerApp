//
//  BasePageViewController.m
//  PageControllerTemplate
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "BasePageViewController.h"

@interface BasePageViewController ()

@end

@implementation BasePageViewController

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    uint index = viewController.view.tag;
    if((index+1) == self.mPageViewControllers.count)
        return nil;
    
    return self.mPageViewControllers[index+1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    uint index = viewController.view.tag;

    if(self.mBasePageViewDelegate && [self.mBasePageViewDelegate respondsToSelector:@selector(changedToPage:)])
        [self.mBasePageViewDelegate changedToPage:index];
    
    if(index == 0)
        return Nil;
    else
        return self.mPageViewControllers[index-1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.mPageViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
//    if(self.mPageNibNames && self.mPageNibNames.count > 0)
//    {
//        for (NSString* nibName in self.mPageNibNames)
//        {
//            UIViewController* viewController = [[UIViewController alloc] initWithNibName:nibName bundle:nil];
//            if(viewController)
//               [self.mPageViewControllers addObject:viewController];
//        }
//    }
    
    if(self.mPageViewControllers && self.mPageViewControllers.count > 0)
    {
        uint index = 0;
        for (UIViewController* viewController in self.mPageViewControllers)
        {
            viewController.view.tag = index++;
        }
    }
	// Do any additional setup after loading the view.
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
    
    self.pageController.dataSource = self;
    UIViewController *initialViewController = self.mPageViewControllers[0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
