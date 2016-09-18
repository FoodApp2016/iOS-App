//
//  RestaurantUpdateItemTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/8/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantUpdateItemTableViewController.h"
#import "Restaurant.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Constants.h"
#import "RequestHandler.h"

@interface RestaurantUpdateItemTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *leftoversItemTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityAvailableTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation RestaurantUpdateItemTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    self.leftoversItemTextField.text = restaurant.leftoversItem ? restaurant.leftoversItem : @"";
    self.priceTextField.text = restaurant.price > 0 ? [NSString stringWithFormat:@"$%.2f", restaurant.price * 1. / 100] : @"";
    self.quantityAvailableTextField.text = restaurant.quantityAvailable > 0 ? [NSString stringWithFormat:@"%d", restaurant.quantityAvailable] : @"";
    
    self.textFields = @[self.leftoversItemTextField,
                        self.priceTextField,
                        self.quantityAvailableTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (int)frontEndPriceToPrice {
    
    return (int)([self.priceTextField.text doubleValue] * 100);
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [super displayOrHideCompleteAllFieldsHeaderIfRequired];
    
    if (![super allFieldsAreComplete]) {
        return;
    }
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    [[RequestHandler new] updateItem:@{@"leftoversItem": self.leftoversItemTextField.text,
                                       @"price": [NSString stringWithFormat:@"%d", [self frontEndPriceToPrice]],
                                       @"quantityAvailable": self.quantityAvailableTextField.text,
                                       @"username": restaurant.username,
                                       @"password": restaurant.password}
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
                       if (error) {
                           NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                       }
    }];
}

@end
