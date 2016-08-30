//
//  Customer.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/26/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Customer.h"

@implementation Customer

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    for (NSString *key in [dict allKeys]) {
        [self setValue:dict[key] forKey:key];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.id_ = (int)[coder decodeIntegerForKey:@"id_"];
    self.name = [coder decodeObjectForKey:@"name"];
    self.facebookId = [coder decodeObjectForKey:@"facebookId"];
    self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
    self.stripeId = [coder decodeObjectForKey:@"stripeId"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInteger:self.id_ forKey:@"id_"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.facebookId forKey:@"facebookId"];
    [coder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:self.stripeId forKey:@"stripeId"];
}

@end
