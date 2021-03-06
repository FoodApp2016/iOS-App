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

NSString * const kIncorrectFormatErrorDescription =
    @"The data couldn’t be read because it isn’t in the correct format.";
NSString * const kInvalidCredentialsHeaderText = @"INVALID CREDENTIALS.";

@interface RestaurantLoginTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RestaurantLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.loginButton.layer.cornerRadius = 3.5;
    self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [self.loginButton sizeToFit];
    
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
    return 3;
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
            return;
        }

                             NSDictionary *restaurantDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:0
                                                                                              error:&error];
                             
        if (error) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
            if ([error.localizedDescription isEqual:kIncorrectFormatErrorDescription]) {
                self.headerText = kInvalidCredentialsHeaderText;
                [super displayHeader];
                return;
            }
        }
                             
        if ([restaurantDict[@"isActivated"] intValue]) {
         
            Restaurant *restaurant = [[Restaurant alloc] initWithJson:restaurantDict];
            [[NSUserDefaults standardUserDefaults] saveRestaurant:restaurant
                                                           key:kNSUserDefaultsRestaurantKey];

            if (![restaurant.description_ isEqual:@""]) {
             
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UITabBarController *viewController =
                    [storyboard instantiateViewControllerWithIdentifier:kRestaurantTabBarControllerIdentifier];
                    [self.navigationController presentViewController:viewController animated:YES completion:nil];
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
