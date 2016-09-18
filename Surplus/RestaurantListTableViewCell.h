//
//  RestaurantListTableViewCell.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/18/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableViewCell.h"

@interface RestaurantListTableViewCell : ListTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *leftoversItem;
@property (weak, nonatomic) IBOutlet UIView *backgroundView_;

@end
