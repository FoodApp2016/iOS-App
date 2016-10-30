//
//  RestaurantOrdersTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/11/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantOrdersTableViewController.h"
#import "Order.h"
#import "RequestHandler.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Constants.h"
#import "ReceiptListTableViewCell.h"

@interface RestaurantOrdersTableViewController ()

@end

@implementation RestaurantOrdersTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self populateOrders];
}

- (void)populateOrders {
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    [[RequestHandler new] getAllOrdersForRestaurant:restaurant.id_
                                  completionHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error) {
        [super populateOrdersCompletionHandlerWithData:data error:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self presentCompleteOrderConfirmationAlertWithIndexPath:indexPath handler:^{
        [self completeOrderWithIndexPath:indexPath];
    }];
}

- (void)completeOrderWithIndexPath:(NSIndexPath *)indexPath {
    
    unsigned int orderId = [self.orders[indexPath.row] id_];
    
    [[RequestHandler new] completeOrder:orderId
                      completionHandler:^(NSData *data,
                                          NSURLResponse *response,
                                          NSError *error) {
        
        if (error) {
          NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
          return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:&error];

        if (error) {
          NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
          return;
        }

        if (!json[@"isCompleted"]) {
          NSLog(@"%s %@", __PRETTY_FUNCTION__, json);
          return;
        }

        Order *order = self.orders[indexPath.row];
        order.isCompleted = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
    }];
}

- (void)presentCompleteOrderConfirmationAlertWithIndexPath:(NSIndexPath *)indexPath
                                            handler:(void(^)(void))handler {
    
    unsigned int orderId = [self.orders[indexPath.row] id_];
    NSString *message = [NSString stringWithFormat:@"Mark order #%d as complete?", orderId];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Confirm"
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Complete"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}

@end























