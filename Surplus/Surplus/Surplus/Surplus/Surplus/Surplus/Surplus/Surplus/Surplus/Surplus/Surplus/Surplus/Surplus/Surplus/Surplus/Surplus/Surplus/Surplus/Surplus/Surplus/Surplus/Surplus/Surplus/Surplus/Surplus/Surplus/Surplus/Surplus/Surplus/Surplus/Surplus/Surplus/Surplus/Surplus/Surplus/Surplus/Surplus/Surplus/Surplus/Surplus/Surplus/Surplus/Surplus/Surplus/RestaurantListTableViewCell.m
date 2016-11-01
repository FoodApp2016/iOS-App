//
//  RestaurantListTableViewCell.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/18/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantListTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RestaurantListTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.backgroundView_.layer.masksToBounds = NO;
//    self.backgroundView_.layer.cornerRadius = 2;
//    self.backgroundView_.layer.shadowOffset = CGSizeMake(0, 1);
//    self.backgroundView_.layer.shadowRadius = 1;
//    self.backgroundView_.layer.shadowOpacity = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
