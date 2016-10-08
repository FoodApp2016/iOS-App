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
#import "RequestHandler.h"

@interface RestaurantViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *leftoversItem;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextView *description_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *pickupStartTime;
@property (weak, nonatomic) IBOutlet UILabel *pickupEndTime;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.name.text = self.restaurant.name;
    self.pickupStartTime.text = self.restaurant.pickupStartTime;
    self.pickupEndTime.text = self.restaurant.pickupEndTime;
    self.leftoversItem.text = self.restaurant.leftoversItem;
    self.price.text = [NSString stringWithFormat:@"$%.2f", (double) self.restaurant.price / 100];
    
    self.description_.editable = YES;
    self.description_.text = self.restaurant.description_;
    
    self.descriptionHeightConstraint.constant = [self.description_ sizeThatFits:CGSizeMake(self.description_.frame.size.width, CGFLOAT_MAX)].height + 20;

    self.description_.editable = NO;
    
    self.quantityTextField.delegate = self;
    
    self.quantityStepper.value = 1;
    self.quantityStepper.minimumValue = 1;
    self.quantityStepper.maximumValue = self.restaurant.quantityAvailable;
    
    self.displayImage.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)quantityStepperValueChanged:(id)sender {
    self.quantityTextField.text = [NSString stringWithFormat:@"%d", (int)self.quantityStepper.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    double quantity = [self.quantityTextField.text intValue];
    OrderConfirmationTableViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.order = [[Order alloc] initWithRestaurant:self.restaurant quantity:quantity];
    // [destinationViewController initializeWithPaymentAmount:self.restaurant.price * quantity];
}

@end
