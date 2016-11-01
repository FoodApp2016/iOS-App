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
                                    
        if (self.orderWasPlaced) {
            [self getRestaurantAndPresentMoreInfoAlertControllerForRestaurantId:self.orders[0].restaurantId];
            self.orderWasPlaced = NO;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    int restaurantId = self.orders[indexPath.row].restaurantId;
    [self getRestaurantAndPresentMoreInfoAlertControllerForRestaurantId:restaurantId];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getRestaurantAndPresentMoreInfoAlertControllerForRestaurantId:(unsigned int)restaurantId {
    
    [[RequestHandler new] getRestaurant:restaurantId
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
                                                    
        Restaurant *restaurant = [[Restaurant alloc] initWithJson:json];

        if (error) {
          NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
          return;
        }

        [self presentMoreInfoAlertControllerForRestaurant:restaurant];
    }];
}

- (void)presentMoreInfoAlertControllerForRestaurant:(Restaurant *)restaurant {
    
    NSString *message = [self messageForRestaurant:restaurant];
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Order Info"
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (NSString *)messageForRestaurant:(Restaurant *)restaurant {
    
    return [NSString stringWithFormat:@"You can collect your order from %@, located at %@, between %@ and %@. Present the unique order token (bolded and in red) for this order to the cashier to receive your order. You will pay the cashier in person for your order, by cash or credit card. For further assistance, please call the restaurant at %@. Enjoy!",
            restaurant.name,
            restaurant.address,
            restaurant.pickupStartTime,
            restaurant.pickupEndTime,
            restaurant.phoneNumber];
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
