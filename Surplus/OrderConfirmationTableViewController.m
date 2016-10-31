//
//  OrderConfirmationTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/19/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "OrderConfirmationTableViewController.h"
#import "Constants.h"
#import "StripeApiAdapter.h"
#import "RequestHandler.h"
#import "CustomerOrdersViewController.h"

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
    
    [self initializeWithPaymentAmount:self.order.quantity * self.order.unitPrice];
    
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
    
    return self.order.quantity * self.order.unitPrice / 100.0;
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
    
    [[RequestHandler new] makePostRequestWithUrlString:[kSurplusRestlessBaseUrl stringByAppendingString: kSurplusOrderPath]
                                                params:[self.order json]
                                     completionHandler:^(NSData *data, NSURLResponse
                                                         *response,
                                                         NSError *error) {
        completion(error);
    }];
}

- (void)paymentContext:(STPPaymentContext *)paymentContext
   didFinishWithStatus:(STPPaymentStatus)status
                 error:(nullable NSError *)error {
    
    if (status == STPPaymentStatusUserCancellation) {
        return;
    }

    if (status == STPPaymentStatusError) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error..."
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [self.navigationController presentViewController:alert
                                                animated:YES
                                              completion:nil];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:1];
        CustomerOrdersViewController *customerOrdersViewController =
            (CustomerOrdersViewController *)navigationController.topViewController;
        customerOrdersViewController.orderWasPlaced = YES;
        self.tabBarController.selectedViewController = navigationController;
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

@end
