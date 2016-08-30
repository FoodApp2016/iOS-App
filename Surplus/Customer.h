//
//  Customer.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/26/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject<NSCoding>

@property (nonatomic) unsigned int id_;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *stripeId;
@property (strong, nonatomic) NSString *phoneNumber;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
