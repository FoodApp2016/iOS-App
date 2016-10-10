//
//  RestaurantSignUpTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/5/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantSignUpTableViewController.h"
#import "RequestHandler.h"
#import "Restaurant.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "Constants.h"

@interface RestaurantSignUpTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic) BOOL shouldDisplayDatePicker;

@end

@implementation RestaurantSignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpButton.layer.borderWidth = 1;
    self.signUpButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.signUpButton.layer.cornerRadius = 3.5;
    self.signUpButton.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [self.signUpButton sizeToFit];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.shouldDisplayDatePicker = NO;
    
    self.textFields = @[self.emailIdTextField,
                        self.passwordTextField,
                        self.restaurantNameTextField,
                        self.phoneNumberTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (IBAction)nextButtonPressed:(id)sender {
    
    [super displayOrHideCompleteAllFieldsHeaderIfRequired];
    
    if (![self allFieldsAreComplete]) {
        return;
    }
    
    [[RequestHandler new] createNewRestaurant:@{@"username": self.emailIdTextField.text,
                                                @"password": self.passwordTextField.text,
                                                @"name": self.restaurantNameTextField.text,
                                                @"phoneNumber": self.phoneNumberTextField.text}
                                        completionHandler:^(NSData *data,
                                                            NSURLResponse *response,
                                                            NSError *error) {
                                            
        if (error) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
            return;
        }
                                            
        [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (error) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
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
