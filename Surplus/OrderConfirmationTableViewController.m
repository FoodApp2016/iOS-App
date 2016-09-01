//
//  OrderConfirmationTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "OrderConfirmationTableViewController.h"
#import "StripeApiAdapter.h"
#import "RequestHandler.h"

@interface OrderConfirmationTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *leftoversItem;
@property (weak, nonatomic) IBOutlet UILabel *quantity;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *subtotal;
@property (weak, nonatomic) IBOutlet UILabel *tax;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UITableViewCell *orderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *paymentMethodCell;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethod;

@property (strong, nonatomic) STPPaymentContext *paymentContext;
@property (weak, nonatomic) IBOutlet UILabel *orderCellLabel;

@end

@implementation OrderConfirmationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.leftoversItem.text = self.order.itemName;
    self.quantity.text = [NSString stringWithFormat:@"%d", self.order.quantity];
    self.unitPrice.text = [NSString stringWithFormat:@"$%.2f", (double) self.order.unitPrice / 100];
    self.subtotal.text =
    [NSString stringWithFormat:@"$%.2f", [self subtotalInDollars]];
    self.tax.text = @"$0.00";
    self.total.text = self.subtotal.text;
    
    self.orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeWithPaymentAmount:(int)subtotal {
    
    StripeApiAdapter *apiAdapter = [StripeApiAdapter new];
    self.paymentContext = [[STPPaymentContext alloc] initWithAPIAdapter:apiAdapter];
    self.paymentContext.delegate = self;
    self.paymentContext.hostViewController = self;
    self.paymentContext.paymentAmount = subtotal;
}

- (double)subtotalInDollars {
    
    return self.paymentContext.paymentAmount / 100;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 1;
    }
    return 0;
}

#pragma mark - STPPaymentContext delegate methods

- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
    
    NSString *paymentMethod = paymentContext.selectedPaymentMethod.label;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (paymentMethod) {
            self.paymentMethod.text = paymentMethod;
            self.orderCellLabel.textColor = [UIColor blackColor];
            return;
        }
        
        self.paymentMethod.text = @"Select Method";
    });
}

- (void)paymentContext:(STPPaymentContext *)paymentContext
didCreatePaymentResult:(nonnull STPPaymentResult *)paymentResult
            completion:(nonnull STPErrorBlock)completion {
    
    [[RequestHandler new] chargeCustomerWithOrder:self.order
                                           source:paymentResult.source.stripeID
                                completionHandler:^(NSError *error,
                                                    NSData *data) {
        completion(error);
    }];
}

- (void)paymentContext:(STPPaymentContext *)paymentContext
   didFinishWithStatus:(STPPaymentStatus)status
                 error:(nullable NSError *)error {
    
    if (status == STPPaymentStatusUserCancellation) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    if (status == STPPaymentStatusError) {
        alert.title = @"Error...";
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:alert
                                                animated:YES
                                              completion:nil];
    });

    return;
}

- (void)paymentContext:(STPPaymentContext *)paymentContext
didFailToLoadWithError:(nonnull NSError *)error {
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        [self.paymentContext pushPaymentMethodsViewController];
    }
    
    if (indexPath.section == 3) {
        [self.paymentContext requestPayment];
    }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
