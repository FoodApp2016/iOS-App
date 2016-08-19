//
//  Restaurant.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/17/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Contacts;
@import UIKit;

@interface Restaurant : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *displayImage;
@property (strong, nonatomic) CNPostalAddress *address;
@property (nonatomic) double rating;
@property (strong, nonatomic) CNPhoneNumber *phoneNumber;
@property (strong, nonatomic) NSString *emailAddress;
@property (nonatomic) NSTimeInterval pickupTime;
@property (strong, nonatomic) NSString *leftoversItem;
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic) double price;

- (id)initWithDict:(NSDictionary *)dict;

@end
