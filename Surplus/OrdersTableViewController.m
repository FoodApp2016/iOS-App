//
//  OrdersTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/15/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "Constants.h"
#import "ReceiptListTableViewCell.h"
#import "Order.h"

@interface OrdersTableViewController ()

@end

@implementation OrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 4)];
    self.tableView.tableHeaderView.backgroundColor = [self grayColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 4)];
    self.tableView.tableFooterView.backgroundColor = [self grayColor];
    self.tableView.backgroundColor = [self grayColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiptListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:kReceiptListTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)grayColor {
    return [UIColor colorWithRed:0.97227 green:0.979203 blue:1 alpha:1];
}

- (void)populateOrdersCompletionHandlerWithData:(NSData *)data
                                         error:(NSError *)error {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (error) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
        return;
    }
    
    NSArray *ordersJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"%@", ordersJson);
    
    if (error) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
        return;
    }
    
    if (ordersJson.count == 0) {
        return;
    }
    
    self.orders = [NSMutableArray new];
    self.names = [NSMutableArray new];
    
    for (NSDictionary *orderJson in [[ordersJson reverseObjectEnumerator] allObjects]) {
        Order *order = [[Order alloc] initWithJson:orderJson];
        [self.orders addObject:order];
        [self.names addObject:orderJson[@"name"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 124;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptListTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kReceiptListTableViewCellIdentifier
                                    forIndexPath:indexPath];
    
    Order *order = self.orders[indexPath.row];
    
    cell.orderIdLabel.text = [NSString stringWithFormat:@"Order #%d", order.id_];
    cell.nameLabel.text = self.names[indexPath.row];
    cell.timestampLabel.text = order.timestamp;
    
    cell.tokenLabel.text = order.randToken;
    
    NSLog(@"%@", order);
    
    if (order.isCompleted) {
        cell.tokenLabel.textColor = [UIColor lightGrayColor];
    }
    
    cell.leftoversItemLabel.text = order.itemName;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%d", order.quantity];
    cell.totalLabel.text = [NSString stringWithFormat:@"$%.2f", order.amount * 1. / 100];
    
    for (UIView *subview in cell.backgroundView_.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            [subview sizeToFit];
        }
    }
    
    return cell;
}


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
