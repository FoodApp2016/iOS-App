//
//  RestaurantLoginTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/6/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantLoginTableViewController.h"
#import "RequestHandler.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Restaurant.h"
#import "Constants.h"
#import "RestaurantUpdateItemTableViewController.h"

@interface RestaurantLoginTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation RestaurantLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textFields = @[self.usernameTextField, self.passwordTextField];
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
    return 2;
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [super displayOrHideCompleteAllFieldsHeaderIfRequired];
    
    if (![self allFieldsAreComplete]) {
        return;
    }
    
    [[RequestHandler new] signRestaurantIn:@{@"username":self.usernameTextField.text,
                                             @"password":self.passwordTextField.text}
                         completionHandler:^(NSData *data,
                                             NSURLResponse *response,
                                             NSError *error) {
    
         if (error) {
             NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
         }
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:&error];
         
         if (error) {
             NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
         }
                             
                             NSLog(@"%@", json);
         
         if ([json[@"isActivated"] intValue]) {
             
             Restaurant *restaurant = [[Restaurant alloc] initWithJson:json];
             [[NSUserDefaults standardUserDefaults] saveRestaurant:restaurant
                                                               key:kNSUserDefaultsRestaurantKey];
             
             if (![restaurant.description_ isEqual:@""]) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     RestaurantUpdateItemTableViewController *viewController =
                     [storyboard instantiateViewControllerWithIdentifier:kRestaurantUpdateItemTableViewControllerIdentifier];
                     [self.navigationController pushViewController:viewController animated:YES];
                 });
                 
                 return;
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self performSegueWithIdentifier:kRestaurantLoginViewControllerLoginButtonSegueIdentifier
                                           sender:nil];
             });

             return;
         }
                             
         dispatch_async(dispatch_get_main_queue(), ^{
             [self displayProcessingRegistrationAlertController];
         });
    }];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
