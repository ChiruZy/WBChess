//
//  RootNavController.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "RootNavController.h"

@interface RootNavController ()

@end

@implementation RootNavController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count <= 1) {
        viewController.hidesBottomBarWhenPushed = NO;
    }
}


@end
