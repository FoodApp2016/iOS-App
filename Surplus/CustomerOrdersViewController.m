//
//  CustomerOrdersViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/15/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "CustomerOrdersViewController.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Customer.h"
#import "RequestHandler.h"
#import "Constants.h"

@interface CustomerOrdersViewController ()

@end

@implementation CustomerOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    Customer* customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    [[RequestHandler new] getAllOrdersForCustomer:customer.id_
                                completionHandler:^(NSData *data,
                                                    NSURLResponse *response,
                                                    NSError *error) {
        [super populateOrdersCompletionHandlerWithData:data error:error];
    }];
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
