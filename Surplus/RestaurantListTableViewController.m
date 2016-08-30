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

- (NSTimeInterval)stringToTimeInterval:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *start = [dateFormatter dateFromString:@"00:00:00"];
    NSDate *end = [dateFormatter dateFromString:string];
    return [end timeIntervalSinceDate:start];
}

- (NSArray *)mockRestaurantData {
    
    CNMutablePostalAddress *joesBuffetAddress = [CNMutablePostalAddress new];
    joesBuffetAddress.street = @"834 Texas St";
    joesBuffetAddress.city = @"Fairfield";
    joesBuffetAddress.state = @"CA";
    joesBuffetAddress.postalCode = @"94533";
    joesBuffetAddress.country = @"USA";
    
    CNMutablePostalAddress *greenBarAddress = [CNMutablePostalAddress new];
    greenBarAddress.street = @"3 Embarcadero Ctr Lobby Level";
    greenBarAddress.city = @"San Francisco";
    greenBarAddress.state = @"CA";
    greenBarAddress.postalCode = @"94111";
    greenBarAddress.country = @"USA";
    
    CNMutablePostalAddress *molinariDelicatessenAddress = [CNMutablePostalAddress new];
    molinariDelicatessenAddress.street = @"373 Columbus Ave";
    molinariDelicatessenAddress.city = @"San Francisco";
    molinariDelicatessenAddress.state = @"CA";
    molinariDelicatessenAddress.postalCode = @"94133";
    molinariDelicatessenAddress.country = @"USA";

    return @[
             @{
                @"name": @"Joe's Buffet",
                @"address": [joesBuffetAddress copy],
                @"rating": [NSNumber numberWithDouble:4.5],
                @"phoneNumber": [CNPhoneNumber phoneNumberWithStringValue:@"(707) 425-2317"],
                @"pickupTime": [NSNumber numberWithDouble:[self stringToTimeInterval:@"21:30:00"]],
                @"leftoversItem": @"Steak",
                @"categories": @[@"Buffets", @"Sandwiches"],
                @"price": [NSNumber numberWithDouble:5]
              },
             
             @{
                 @"name": @"Green Bar",
                 @"address": [greenBarAddress copy],
                 @"rating": [NSNumber numberWithDouble:3.5],
                 @"phoneNumber": [CNPhoneNumber phoneNumberWithStringValue:@"(415) 693-9339"],
                 @"pickupTime": [NSNumber numberWithDouble:[self stringToTimeInterval:@"20:00:00"]],
                 @"leftoversItem": @"Spicy chicken sandwich",
                 @"categories": @[@"American", @"Delis", @"Buffets"],
                 @"price": [NSNumber numberWithDouble:5]
              },
             
             @{
                 @"name": @"Molinari Delicatessen",
                 @"address": [molinariDelicatessenAddress copy],
                 @"rating": [NSNumber numberWithDouble:4.5],
                 @"phoneNumber": [CNPhoneNumber phoneNumberWithStringValue:@"(415) 421-2337"],
                 @"pickupTime": [NSNumber numberWithDouble:[self stringToTimeInterval:@"22:15:00"]],
                 @"leftoversItem": @"Renzo Special",
                 @"categories": @[@"Delis"],
                 @"price": [NSNumber numberWithDouble:5]
              }
    ];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"RestaurantListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kRestaurantListTableViewCellIdentifier];
    
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
//
//    NSMutableArray *restaurantList = [NSMutableArray new];
//
//    for (NSDictionary *restaurant in [self mockRestaurantData]) {
//        [restaurantList addObject:[[Restaurant alloc] initWithDict:restaurant]];
//    }
//    
//    self.restaurantList = [restaurantList copy];
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
    return self.restaurantList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantListTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kRestaurantListTableViewCellIdentifier
                                    forIndexPath:indexPath];
    Restaurant *restaurant = self.restaurantList[indexPath.row];
    
    cell.name.text = restaurant.name;
    cell.displayImage.image = restaurant.displayImage;
    cell.distance.text = [NSString stringWithFormat:@"%.1f mi",
                          [self calculateDistanceFromRestaurant:restaurant]];
    cell.rating.text = [NSString stringWithFormat:@"%.1f", restaurant.rating];
    cell.leftoversItem.text = restaurant.leftoversItem;
    cell.price.text = [NSString stringWithFormat:@"$%.2f", (double) restaurant.price / 100];
    [cell.phoneNumber setTitle:restaurant.phoneNumber.stringValue forState:UIControlStateNormal];
    
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
    
    RestaurantViewController *destinationViewController = segue.destinationViewController;
    int row = (int) [self.tableView indexPathForSelectedRow].row;
    destinationViewController.restaurant = self.restaurantList[row];
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
