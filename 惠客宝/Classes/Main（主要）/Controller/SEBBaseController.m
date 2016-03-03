//
//  SEBBaseController.m
//  商E宝
//
//  Created by 薛银亮 on 15/10/8.
//  Copyright © 2015年 www.30pay.seb. All rights reserved.
//

#import "SEBBaseController.h"
#import "SEBInfiniteScrollView.h"
#import "UIViewController+XYLViewController.h"
#import "SEBTabBarController.h"

@interface SEBBaseController ()

@end

@implementation SEBBaseController

-(instancetype)init
{
    if (self = [super init]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SEBColor(235, 234, 241);
//    [self setupNav];
//    [self setAdvertismentBar];
//    [self addSwipeGestureRecognizer];
}


-(void)viewDidAppear:(BOOL)animated
{
    //打开滑动菜单
    [SEBNotificationCenter postNotificationName:@"enableRESideMenu" object:self userInfo:nil];
    
}

-(void)dealloc
{
    [SEBNotificationCenter removeObserver:self name:@"showUserSettingVC" object:nil];
}

#pragma mark -- 监听方法

-(void)showUserSettingVC
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UserSettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SEBUserSetting"];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
//    self.navigationController.viewControllers.lastObject
}


-(void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
}
-(void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    [self setupScrollView];
}

- (void)buttonClick:(SEBToolButton *)button{}

/**
 *  添加scrollview
 */
-(void)setupScrollView
{
    CGFloat buttonStarY = (SCREEN_HEIGHT - (SEBNavHeight + SEBStatusBarH) - self.tabBarController.tabBar.height) / 3.0f + (SEBNavHeight + SEBStatusBarH) + SEBSmallMargin;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, buttonStarY, SCREEN_WIDTH, SCREEN_HEIGHT - buttonStarY - self.tabBarController.tabBar.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [self setupButtons];
}

/**
 *  功能键设置
 */
- (void)setupButtons
{
    int totalColsCount = 3;
    CGFloat buttonW = SCREEN_WIDTH / totalColsCount;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        SEBToolButton *button = [[SEBToolButton alloc] init];
        CGFloat buttonX = (i % totalColsCount) * buttonW;
        CGFloat buttonY =  (i / totalColsCount) * buttonH;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:self.imagesArray[i]] forState:UIControlStateNormal];
        [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [self.buttons addObject:button];
        [self.scrollView addSubview:button];
    }
    //按钮行数
    int countInt = (int)self.imagesArray.count / totalColsCount;//取整
    int countYu = self.imagesArray.count % totalColsCount;//取余
    int lineCount = (countYu == 0) ? countInt:(countInt + 1);
    self.scrollView.contentSize = CGSizeMake(0, lineCount * buttonW);
}

/**
 *  广告条
 */
-(void)setAdvertismentBar
{
    [self.view addSubview:({
        SEBInfiniteScrollView *scrollView = [[SEBInfiniteScrollView alloc] init];
        scrollView.frame = CGRectMake(0, (SEBNavHeight + SEBStatusBarH), SCREEN_WIDTH, 150);
        scrollView.images = @[
                              [UIImage imageNamed:@"img_00"],
                              [UIImage imageNamed:@"img_01"],
                              [UIImage imageNamed:@"img_02"],
                              [UIImage imageNamed:@"img_03"],
                              [UIImage imageNamed:@"img_04"]
                              ];
        scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        scrollView.scrollDirectionPortrait = NO;
        scrollView.delayTime = 4;
        scrollView;
    })];
}

/**
 *  添加滑动手势
 */
-(void)addSwipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDone)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightDone)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}


/**
 *  设置导航栏
 */
-(void)setupNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:(SEBTabBarController *)self.tabBarController action:@selector(showMenu) imageStr:@"MainTagSubIcon" selectedImageStr:@"MainTagSubIconClick"];
}


#pragma mark -滑动方法

/**
 *  左滑动切换
 */
- (void) swipeLeftDone
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    if (selectedIndex == self.tabBarController.viewControllers.count - 1) {
        return;
    }
    //添加切换动画
//    UIView *fromView = [self.tabBarController.selectedViewController view];
//    UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:(selectedIndex + 1)]view];
//    [UIView transitionFromView:fromView toView:toView duration: 0.5f options:UIViewAnimationOptionTransitionNone completion:^(BOOL finished) {
//        if (finished) {
//
    self.navigationItem.title = self.title;
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
//        }
//    }];
}

/**
 *  右滑动切换
 */
- (void) swipeRightDone
{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    if (selectedIndex > 0) {
        self.navigationItem.title = self.title;
        [self.tabBarController setSelectedIndex:selectedIndex - 1];
    }
}

@end
