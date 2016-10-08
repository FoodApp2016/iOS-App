//
//  CustomerTabBarController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/22/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "CustomerTabBarController.h"
#import "RestaurantTableViewController.h"

@interface CustomerTabBarController ()

@end

@implementation CustomerTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    int index = (int)[tabBarController.viewControllers indexOfObject:viewController];
    
    if (index == 0 && [tabBarController.viewControllers[0] isKindOfClass:[RestaurantTableViewController class]]) {
        UINavigationController *navigationController = tabBarController.viewControllers[0];
        [navigationController popToRootViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
