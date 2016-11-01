//
//  Restaurant.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/17/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Restaurant.h"

#import "NSString+FormattedDateString.h"

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
        self.stripeId = json[@"stripeId"] ?: @"";
        self.username = json[@"username"];
        self.password = json[@"password"];
        self.description_ = json[@"description"]  == [NSNull null] ? @"" : json[@"description"];
        self.leftoversItem = json[@"leftoversItem"]  == [NSNull null] ? @"" : json[@"leftoversItem"];
        self.price = json[@"price"] == [NSNull null] ? 0 : [json[@"price"] intValue];
        self.pickupStartTime = json[@"pickupStartTime"] == [NSNull null] ? @"" : [json[@"pickupStartTime"] formattedDateString];
        self.pickupEndTime = json[@"pickupEndTime"] == [NSNull null] ? @"" : [json[@"pickupEndTime"] formattedDateString];
        self.isActivated = [json[@"isActivated"] boolValue];
        self.phoneNumber = json[@"phoneNumber"];
        self.address = json[@"addressLine1"] ?: @"";
        self.representativeName = json[@"representativeName"] ?: @"";
        self.representativeDateOfBirth = [NSDate date];
        self.quantityAvailable = json[@"quantityAvailable"] == [NSNull null] ? 0 : [json[@"quantityAvailable"] intValue];
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
    self.stripeId = [coder decodeObjectForKey:@"stripeId"];
    self.address = [coder decodeObjectForKey:@"address"];
    self.location = [coder decodeObjectForKey:@"location"];
    self.username = [coder decodeObjectForKey:@"username"];
    self.password = [coder decodeObjectForKey:@"password"];
    self.description_ = [coder decodeObjectForKey:@"description_"];
    self.leftoversItem = [coder decodeObjectForKey:@"leftoversItem"];
    self.price = (int)[coder decodeIntegerForKey:@"price"];
    self.pickupStartTime = [coder decodeObjectForKey:@"pickupStartTime"];
    self.pickupEndTime = [coder decodeObjectForKey:@"pickupEndTime"];
    self.isActivated = [coder decodeBoolForKey:@"isActivated"];
    self.representativeName = [coder decodeObjectForKey:@"representativeName"];
    self.representativeDateOfBirth = [coder decodeObjectForKey:@"representativeDateOfBirth"];
    self.quantityAvailable = (int)[coder decodeIntegerForKey:@"quantityAvailable"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInteger:self.id_ forKey:@"id_"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.stripeId forKey:@"stripeId"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.location forKey:@"location"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.password forKey:@"password"];
    [coder encodeObject:self.description_ forKey:@"description_"];
    [coder encodeObject:self.leftoversItem forKey:@"leftoversItem"];
    [coder encodeInteger:self.price forKey:@"price"];
    [coder encodeObject:self.pickupStartTime forKey:@"pickupStartTime"];
    [coder encodeObject:self.pickupEndTime forKey:@"pickupEndTime"];
    [coder encodeBool:self.isActivated forKey:@"isActivated"];
    [coder encodeObject:self.representativeName forKey:@"representativeName"];
    [coder encodeObject:self.representativeDateOfBirth forKey:@"representativeDateOfBirth"];
    [coder encodeInteger:self.quantityAvailable forKey:@"quantityAvailable"];
}

@end
