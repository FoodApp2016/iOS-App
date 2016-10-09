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
#import "RegExCategories.h"

@interface RestaurantUpdateItemTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *leftoversItemTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic) int price;
@property (weak, nonatomic) IBOutlet UITextField *quantityAvailableTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickupStartTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *pickupStartTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickupEndTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *pickupEndTimeLabel;

@property (nonatomic) BOOL pickupStartTimePickerActive;
@property (nonatomic) BOOL pickupEndTimePickerActive;

@end

@implementation RestaurantUpdateItemTableViewController

- (void)viewDidLoad {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewDidLoad];
    
    self.pickupStartTimePickerActive = NO;
    self.pickupEndTimePickerActive = NO;
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    self.textFields = @[self.leftoversItemTextField,
                        self.priceTextField,
                        self.quantityAvailableTextField];
    
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }
    
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.priceTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
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
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.leftoversItemTextField.text = restaurant.leftoversItem ? restaurant.leftoversItem : @"";
    self.price = restaurant.price;
    self.priceTextField.text = [self priceToFrontEndPrice:restaurant.price];
    self.quantityAvailableTextField.text = [NSString stringWithFormat:@"%d", restaurant.quantityAvailable];
    self.pickupStartTimeLabel.text = restaurant.pickupStartTime;
    self.pickupEndTimeLabel.text = restaurant.pickupEndTime;
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
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *string = [self stringWithoutLeadingDollarSign:self.priceTextField.text];
    return (int)([string doubleValue] * 100);
}

- (NSString *)priceToFrontEndPrice:(int)price {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [NSString stringWithFormat:@"$%.2f", price * 1. / 100];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (![super allFieldsAreComplete]
     || [self.pickupStartTimeLabel.text isEqual:@""]
     || [self.pickupEndTimeLabel.text isEqual:@""]
     || ![self isValidPrice:self.priceTextField.text]) {
        
        [super displayCompleteAllFieldsHeader];
        return;
    }
    else {
        [self hideKeyboardAndPicker];
        [super hideHeader];
    }
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults]
                              loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    [[RequestHandler new] updateItem:@{@"leftoversItem": self.leftoversItemTextField.text,
                                       @"price": [NSString stringWithFormat:@"%d", [self frontEndPriceToPrice]],
                                       @"quantityAvailable": self.quantityAvailableTextField.text,
                                       @"pickupStartTime": self.pickupStartTimeLabel.text,
                                       @"pickupEndTime": self.pickupEndTimeLabel.text,
                                       @"username": restaurant.username,
                                       @"password": restaurant.password}
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
       if (error) {
           NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
           return;
       }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return ![self tableViewContainsPoint:[touch locationInView:self.tableView]];
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CGPoint point = [tapRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath == nil) {
        [self hideKeyboardAndPicker];
    }
}

- (void)hideKeyboardAndPicker {
    
    [self.leftoversItemTextField endEditing:YES];
    [self.priceTextField endEditing:YES];
    [self.quantityAvailableTextField endEditing:YES];
    
    self.pickupStartTimePickerActive = NO;
    self.pickupEndTimePickerActive = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (UIColor *)UITextFieldPlaceholderTextColor {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.pickupStartTimePickerActive = NO;
    self.pickupEndTimePickerActive = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if (textField == self.priceTextField && textField.text.length == 0) {
        textField.text = @"$";
        textField.textColor = [self UITextFieldPlaceholderTextColor];
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (textField.text.length <= 1) {
        textField.text = @"$";
        textField.textColor = [self UITextFieldPlaceholderTextColor];
        return;
    }
    
    if (textField.text.length > 1) {
        textField.textColor = [UIColor blackColor];
    }
    
    if (![self isValidPrice:textField.text]) {
        textField.textColor = [UIColor redColor];
    }
}

- (NSString *)stringWithoutLeadingDollarSign:(NSString *)string {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"$"];
    return [string stringByTrimmingCharactersInSet:characterSet];
}

- (BOOL)isValidPrice:(NSString *)string {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    string = [self stringWithoutLeadingDollarSign:string];
    return [string isMatch:RX(@"^(\\d{1,3}([.]\\d{1,2})?|[.]\\d{1,2})$")];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (textField != self.priceTextField) {
        return YES;
    }
    
    if ([textField.text isEqual:@"$"]) {
        textField.text = @"";
    }
    
    return YES;
}

- (BOOL)tableViewContainsPoint:(CGPoint)point {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint topLeftCorner = cell.frame.origin;
        
        if (point.y >= topLeftCorner.y && point.y <= topLeftCorner.y + cell.frame.size.height) {
            return YES;
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (indexPath.row == 3) {
        self.pickupStartTimePickerActive = !self.pickupStartTimePickerActive;
        self.pickupEndTimePickerActive = NO;
        
        [self.leftoversItemTextField endEditing:YES];
        [self.priceTextField endEditing:YES];
        [self.quantityAvailableTextField endEditing:YES];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        return;
    }
    
    if (indexPath.row == 5) {
        self.pickupEndTimePickerActive = !self.pickupEndTimePickerActive;
        self.pickupStartTimePickerActive = NO;
        
        [self.leftoversItemTextField endEditing:YES];
        [self.priceTextField endEditing:YES];
        [self.quantityAvailableTextField endEditing:YES];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)pickupStartTimePickerValueChanged:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.pickupStartTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.pickupStartTimePicker.date
                                                                    dateStyle:NSDateFormatterNoStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
}

- (IBAction)pickupEndTimePickerValueChanged:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.pickupEndTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.pickupEndTimePicker.date
                                                                  dateStyle:NSDateFormatterNoStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
}

@end










