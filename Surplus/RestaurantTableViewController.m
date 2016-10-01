//
//  RestaurantTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/30/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantTableViewController.h"
#import "OrderConfirmationTableViewController.h"
#import "Order.h"
#import "RequestHandler.h"

@interface RestaurantTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *pickupWindow;
@property (weak, nonatomic) IBOutlet UITextView *addressPhoneNumberTextView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftoversItem;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@end

@implementation RestaurantTableViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    self.name.text = self.restaurant.name;
    self.pickupWindow.text = [NSString stringWithFormat:@"$%.2f  -  %@ to %@",
                              self.restaurant.price * 1. / 100,
                              self.restaurant.pickupStartTime,
                              self.restaurant.pickupEndTime];
    
    self.addressPhoneNumberTextView.text = [NSString stringWithFormat:@"%@ - %@",
                                            self.restaurant.address,
                                            self.restaurant.phoneNumber];
    self.descriptionLabel.text = self.restaurant.description_;
    self.leftoversItem.text = self.restaurant.leftoversItem;
    
    self.quantity.delegate = self;
    
    self.quantityStepper.value = 1;
    self.quantityStepper.minimumValue = 1;
    self.quantityStepper.maximumValue = self.restaurant.quantityAvailable;
    
    self.displayImageView.image = nil;
    
    [[RequestHandler new] getImageForRestaurantId:self.restaurant.id_
                                completionHandler:^(NSData *data,
                                                    NSURLResponse *response,
                                                    NSError *error) {
                                    
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayImageView.image = [UIImage imageWithData:data];
        });
    }];
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
    return 8;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)quantityStepperValueChanged:(id)sender {
    self.quantity.text = [NSString stringWithFormat:@"%d", (int)self.quantityStepper.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    double quantity = [self.quantity.text intValue];
    OrderConfirmationTableViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.order = [[Order alloc] initWithRestaurant:self.restaurant quantity:quantity];
    [destinationViewController initializeWithPaymentAmount:self.restaurant.price * quantity];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
