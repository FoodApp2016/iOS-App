//
//  OrdersTableViewController.h
//  Surplus
//
//  Created by Dhruv Manchala on 9/15/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrdersTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<Order *> *orders;
@property (strong, nonatomic) NSMutableArray *names;

- (void)populateOrdersCompletionHandlerWithData:(NSData *)data
                                          error:(NSError *)error;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
