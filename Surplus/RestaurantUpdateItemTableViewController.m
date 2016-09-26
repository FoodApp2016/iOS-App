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
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) BOOL pickupStartTimePickerActive;
@property (nonatomic) BOOL pickupEndTimePickerActive;

@end

@implementation RestaurantUpdateItemTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pickupStartTimePickerActive = NO;
    self.pickupEndTimePickerActive = NO;
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    self.textFields = @[self.leftoversItemTextField,
                        self.priceTextField,
                        self.quantityAvailableTextField];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(handleTap:)];
    self.tapGestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:self.tapGestureRecognizer];
    
    [self updateUIWithRestaurant:restaurant];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    __block Restaurant *restaurant = [[NSUserDefaults standardUserDefaults]
                                      loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    [[RequestHandler new] getRestaurant:restaurant.id_
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
                          
        restaurant = [[Restaurant alloc] initWithJson:json];
        [[NSUserDefaults standardUserDefaults] saveRestaurant:restaurant key:kNSUserDefaultsRestaurantKey];
                          
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithRestaurant:restaurant];
        });
    }];
}

- (void)updateUIWithRestaurant:(Restaurant *)restaurant {
    
    self.leftoversItemTextField.text = restaurant.leftoversItem ? restaurant.leftoversItem : @"";
    self.priceTextField.text = restaurant.price > 0 ? [NSString stringWithFormat:@"$%.2f", restaurant.price * 1. / 100] : @"";
    self.quantityAvailableTextField.text = restaurant.quantityAvailable > 0 ? [NSString stringWithFormat:@"%d", restaurant.quantityAvailable] : @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        if (self.pickupStartTimePickerActive) {
            return 200;
        }
        
        return 0;
    }
    
    if (indexPath.row == 6) {
        if (self.pickupEndTimePickerActive) {
            return 200;
        }
        
        return 0;
    }
    
    return UITableViewAutomaticDimension;
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSLog(@"%d", indexPath == nil);

    return indexPath == nil;
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGPoint point = [tapRecognizer locationInView:self.tableView];
    
    NSLog(@"%f %f", point.x, point.y);
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath == nil) {
        [self.leftoversItemTextField endEditing:YES];
        [self.priceTextField endEditing:YES];
        [self.quantityAvailableTextField endEditing:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.row == 3) {
        self.pickupStartTimePickerActive = !self.pickupStartTimePickerActive;
        self.pickupEndTimePickerActive = NO;
        [self.tableView reloadData];
    }
    
    if (indexPath.row == 5) {
        self.pickupEndTimePickerActive = !self.pickupEndTimePickerActive;
        self.pickupStartTimePickerActive = NO;
        [self.tableView reloadData];
    }
}

@end










