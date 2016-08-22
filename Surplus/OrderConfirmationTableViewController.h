//
//  OrderConfirmationTableViewController.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderConfirmationTableViewController : UITableViewController

@property (strong, nonatomic) Order *order;

@end
