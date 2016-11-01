//
//  RestaurantFormTableViewController.h
//  Surplus
//
//  Created by Dhruv Manchala on 9/6/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantFormTableViewController : UITableViewController

@property (nonatomic) BOOL shouldDisplayHeader;
@property (nonatomic) NSString *headerText;
@property (strong, nonatomic) NSArray *textFields;

- (BOOL)allFieldsAreComplete;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)displayProcessingRegistrationAlertController;
- (void)displayOrHideCompleteAllFieldsHeaderIfRequired;
- (void)displayCompleteAllFieldsHeader;
- (void)displayHeader;
- (void)hideHeader;

@end
