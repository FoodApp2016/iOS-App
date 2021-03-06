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
@import CoreLocation;

@interface Restaurant : NSObject<NSCoding>

@property (nonatomic) int id_;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *stripeId;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *description_;
@property (strong, nonatomic) NSString *leftoversItem;
@property (nonatomic) unsigned int price;
@property (nonatomic) NSString *pickupStartTime;
@property (nonatomic) NSString *pickupEndTime;
@property (nonatomic) BOOL isActivated;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *representativeName;
@property (strong, nonatomic) NSDate *representativeDateOfBirth;
@property (nonatomic) int quantityAvailable;

@property (strong, nonatomic) UIImage *displayImage;
@property (nonatomic) double rating;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithJson:(NSDictionary *)json;

@end
