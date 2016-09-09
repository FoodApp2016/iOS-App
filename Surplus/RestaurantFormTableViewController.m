//
//  RestaurantFormTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/6/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantFormTableViewController.h"

@interface RestaurantFormTableViewController ()

@end

@implementation RestaurantFormTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldDisplayCompleteAllFieldsHeader = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.shouldDisplayCompleteAllFieldsHeader) {
        return UITableViewAutomaticDimension;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {

    UITableViewHeaderFooterView *header = view;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.textColor = [UIColor redColor];
}

- (void)displayProcessingRegistrationAlertController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thank you!"
                                                                             message:@"Your registration is being processed, and we will get back to you in 24 hours. Please check your email for further instructions."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }];
    [alertController addAction:action];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)displayOrHideCompleteAllFieldsHeaderIfRequired {
    
    if (![self allFieldsAreComplete]) {
        self.shouldDisplayCompleteAllFieldsHeader = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        });
        
        return;
    }
    
    self.shouldDisplayCompleteAllFieldsHeader = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    });
}

- (BOOL)allFieldsAreComplete {

    for (UITextField *textField in self.textFields) {
        if ([textField.text isEqual:@""]) {
            return NO;
        }
    }
    
    return YES;
}

@end
