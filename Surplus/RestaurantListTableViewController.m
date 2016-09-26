//
//  RestaurantListTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/17/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantListTableViewController.h"
#import "Constants.h"
#import "Restaurant.h"
#import "RestaurantListTableViewCell.h"
#import "RestaurantViewController.h"
#import "RequestHandler.h"

@import Contacts;

@interface RestaurantListTableViewController ()

@property (strong, nonatomic) NSArray *restaurantList;

@end

@implementation RestaurantListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"RestaurantListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kRestaurantListTableViewCellIdentifier];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 4)];
    self.tableView.tableHeaderView.backgroundColor = [self grayColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 4)];
    self.tableView.tableFooterView.backgroundColor = [self grayColor];
    self.tableView.backgroundColor = [self grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[RequestHandler new] getAllRestaurants:^(NSError *error,
                                              NSData *data) {
        
        if (error) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
            return;
        }
        
        NSArray *restaurantsJson = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *restaurants = [NSMutableArray new];
        
        for (NSDictionary *restaurantJson in restaurantsJson) {
            Restaurant *restaurant = [[Restaurant alloc] initWithJson:restaurantJson];
            [restaurants addObject:restaurant];
        }
        
        self.restaurantList = [restaurants copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (UIColor *)grayColor {
    return [UIColor colorWithRed:0.97227 green:0.979203 blue:1 alpha:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurantList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.width / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantListTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kRestaurantListTableViewCellIdentifier
                                    forIndexPath:indexPath];
    Restaurant *restaurant = self.restaurantList[indexPath.row];
    
    cell.name.text = restaurant.name;
    cell.distance.text = [NSString stringWithFormat:@"%.1f mi",
                          [self calculateDistanceFromRestaurant:restaurant]];
    cell.rating.font = [UIFont fontWithName:@"FontAwesome" size:17.];
    cell.rating.text = @"4";
    cell.priceLabel.text =  [NSString stringWithFormat:@"$%.2f", (restaurant.price * 1.) / 100];
    cell.leftoversItem.text = restaurant.leftoversItem;
    
    [[RequestHandler new] getImageForRestaurantId:restaurant.id_
                                completionHandler:^(NSData *data,
                                                    NSURLResponse *response,
                                                    NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.displayImage.image = [UIImage imageWithData:data];
            [self.tableView reloadData];
        });
    }];
    
    return cell;
}

- (double)calculateDistanceFromRestaurant:(Restaurant *)restaurant {
    
    int distances[] = {4.5, 3.7, 6.6};
    return distances[arc4random() % 3];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kRestaurantListTableViewCellSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:kRestaurantListTableViewCellSegueIdentifier]) {
        RestaurantViewController *destinationViewController = segue.destinationViewController;
        int row = (int) [self.tableView indexPathForSelectedRow].row;
        destinationViewController.restaurant = self.restaurantList[row];
    }
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
