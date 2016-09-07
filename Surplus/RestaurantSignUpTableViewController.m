//
//  RestaurantSignUpTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/5/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantSignUpTableViewController.h"

@interface RestaurantSignUpTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantAddressTextField;
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
                        self.restaurantAddressTextField,
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
    
    self.dateOfBirthLabel.text = [NSDateFormatter localizedStringFromDate:self.datePicker.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (IBAction)nextButtonPressed:(id)sender {
    [super buttonPressed:sender
                 handler:^() {
        [self displayProcessingRegistrationAlertController];
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
