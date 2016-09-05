//
//  RestaurantViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/18/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantViewController.h"
#import "OrderConfirmationTableViewController.h"
#import "Order.h"

@interface RestaurantViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *leftoversItem;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextView *description_;
@property (weak, nonatomic) IBOutlet UILabel *pickupTime;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.name.text = self.restaurant.name;
    // self.displayImage.image =  self.restaurant.displayImage;
    self.distance.text = [NSString stringWithFormat:@"%.1f mi",
                          [self calculateDistanceFromRestaurant:self.restaurant]];
    self.rating.text = [NSString stringWithFormat:@"%.1f", self.restaurant.rating];
    self.leftoversItem.text = self.restaurant.leftoversItem;
    self.price.text = [NSString stringWithFormat:@"$%.2f", (double) self.restaurant.price / 100];
    [self.phoneNumber setTitle:self.restaurant.phoneNumber.stringValue
                      forState:UIControlStateNormal];
    self.quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double)calculateDistanceFromRestaurant:(Restaurant *)restaurant {
    
    int distances[] = {4.5, 3.7, 6.6};
    return distances[arc4random() % 3];
    
}

- (IBAction)quantityTextFieldValueChanged:(id)sender {

    if ([self.quantityTextField.text intValue] > self.quantityStepper.maximumValue) {
        self.quantityTextField.text = [NSString stringWithFormat:@"%d", (int) self.quantityStepper.maximumValue];
    }
    
    self.quantityStepper.value = [self.quantityTextField.text doubleValue];
}

- (IBAction)quantityStepperValueChanged:(id)sender {
    self.quantityTextField.text = [NSString stringWithFormat:@"%d", (int)self.quantityStepper.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    double quantity = [self.quantityTextField.text intValue];
    OrderConfirmationTableViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.order = [[Order alloc] initWithRestaurant:self.restaurant quantity:quantity];
    [destinationViewController initializeWithPaymentAmount:self.restaurant.price * quantity];
}

@end
