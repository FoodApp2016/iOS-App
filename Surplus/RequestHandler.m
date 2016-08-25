//
//  RequestHandler.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/24/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RequestHandler.h"
#import "Constants.h"

@implementation RequestHandler

-(void)getAllRestaurants:(void (^)(NSError *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"GET";
    NSString *requestString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetAllRestaurantsPath];
    NSURL *url = [NSURL URLWithString:requestString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData * _Nullable data,
                                                    NSURLResponse * _Nullable response,
                                                    NSError * _Nullable error) {
        completionHandler(error, data);
    }] resume];
}

@end
