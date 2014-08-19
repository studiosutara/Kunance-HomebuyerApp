//
//  BasePageViewController.h
//  PageControllerTemplate
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasePageViewDelegate <NSObject>
-(void) changedToPage:(uint) index;
@end

@interface BasePageViewController : UIViewController <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* mPageNibNames;
@property (nonatomic, strong) UIPageViewController* pageController;
@property (nonatomic, strong) NSMutableArray* mPageViewControllers;
@property (nonatomic, strong) UIImageView* mbackground;
@property (nonatomic, weak) id <BasePageViewDelegate> mBasePageViewDelegate;
@end
