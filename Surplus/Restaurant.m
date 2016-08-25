//
//  Restaurant.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/17/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (id)initWithDict:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self) {
        for (NSString *key in dict.allKeys) {
            if ([key isEqual:@"rating"]) {
                self.rating = [dict[key] doubleValue];
            }
            else if ([key isEqual:@"price"]) {
                self.price = [dict[key] doubleValue];
            }
            else if ([key isEqual:@"pickupTime"]) {
                self.pickupTime = [dict[key] doubleValue];
            }
            else {
                [self setValue:dict[key] forKey:key];
            }
        }
    }
    
    return self;
}

- (id)initWithJson:(NSDictionary *)json {
    
    self = [super init];
    
    if (self) {
        self.id_ = [json[@"id"] intValue];
        self.name = json[@"name"];
        self.address = json[@"address"];
    }

    
    return self;
}

@end
