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
@property (weak, nonatomic) IBOutlet UITextField *representativeNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic) BOOL shouldDisplayDatePicker;

@end

@implementation RestaurantSignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.shouldDisplayDatePicker = NO;
    
    self.textFields = @[self.emailIdTextField,
                        self.passwordTextField,
                        self.restaurantNameTextField,
                        self.phoneNumberTextField,
                        self.representativeNameTextField];
    
    self.dateOfBirthLabel.text = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
        
        if (self.shouldDisplayDatePicker) {
            return 216;
        }
        
        return 0;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        self.shouldDisplayDatePicker = !self.shouldDisplayDatePicker;
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

- (IBAction)datePickerValueChanged:(id)sender {
    
    self.dateOfBirthLabel.text = [NSDateFormatter localizedStringFromDate:self.datePicker.date
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle];
}

- (IBAction)nextButtonPressed:(id)sender {
    
    [super displayOrHideCompleteAllFieldsHeaderIfRequired];
    
    if (![self allFieldsAreComplete]) {
        return;
    }
    
    [[RequestHandler new] createNewRestaurantWithUsername:self.emailIdTextField.text
                                                 password:self.passwordTextField.text
                                                     name:self.restaurantNameTextField.text
                                              phoneNumber:self.phoneNumberTextField.text
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
                                            
        Restaurant *restaurant = [[Restaurant alloc] initWithJson:json];
        [[NSUserDefaults standardUserDefaults] saveRestaurant:restaurant
                                                          key:kNSUserDefaultsRestaurantKey];
                                            
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayProcessingRegistrationAlertController];
        });
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
