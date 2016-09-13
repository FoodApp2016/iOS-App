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

@interface RestaurantOrdersTableViewController ()

@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation RestaurantOrdersTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.orders = [NSMutableArray new];
    
    [self populateOrders];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateOrders {
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    [[RequestHandler new] getAllOrdersForRestaurant:restaurant.id_
                                  completionHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error) {
                                      
                                      if (error) {
                                          NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                                          return;
                                      }
                                      
                                      NSArray *ordersJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      
                                      if (error) {
                                          NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                                          return;
                                      }
                                      
                                      NSLog(@"%@", ordersJson);
                                      
                                      for (NSDictionary *orderJson in ordersJson) {
                                          Order *order = [[Order alloc] initWithJson:orderJson];
                                          [self.orders addObject:order];
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                      });
 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

@end
