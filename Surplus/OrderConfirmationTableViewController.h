//
//  OrderConfirmationTableViewController.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@import Stripe;

@interface OrderConfirmationTableViewController: UITableViewController<STPPaymentContextDelegate>

@property (strong, nonatomic) Order *order;

- (void)initializeWithPaymentAmount:(int)subtotal;

@end
