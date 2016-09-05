//
//  RequestHandler.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/24/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RequestHandler.h"
#import "Constants.h"
#import "NSUserDefaults+CustomObjectStorage.h"

@implementation RequestHandler

- (NSString *)appendParams:(NSDictionary *)params toUrlString:(NSString *)urlString {
    
    NSMutableString *finalUrlString = [urlString mutableCopy];
    [finalUrlString appendString:@"?"];
    
    NSArray *keys = [params allKeys];
    
    for (int i = 0; i < params.count; ++i) {
        
        [finalUrlString appendFormat:@"%@=%@", keys[i], params[keys[i]]];
        
        if (i < params.count - 1) {
            [finalUrlString appendFormat:@"&"];
        }
    }
    
    return finalUrlString;
}

- (void)makeGetRequest:(NSString *)urlString
                params:(NSDictionary *)params
     completionHandler:(void (^)(NSError *, NSData *))completionHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"GET";
    urlString = [self appendParams:params toUrlString:urlString];
    NSURL *url =
    [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:
                          [NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData * _Nullable data,
                                                     NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
        completionHandler(error, data);
    }] resume];
}

- (void)getAllRestaurants:(void (^)(NSError *, NSData *))completionHandler {
    
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

- (void)getOrCreateCustomerWithName:(NSString *)name
                         facebookId:(NSString *)facebookId
                  completionHandler:(void (^)(NSError *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *requestString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetOrAddCustomerPath];
    [self makeGetRequest:requestString
                  params:@{@"name": name, @"facebookId": facebookId}
       completionHandler:^(NSError *error,
                           NSData *data) {
           completionHandler(error, data);
    }];
}

- (void)getStripeCustomer:(NSString *)stripeId
        completionHandler:(void (^)(NSError *, NSURLResponse *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey] name]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"GET";
    NSString *requestString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetStripeCustomerPath];
    requestString = [self appendParams:@{@"stripeId": stripeId} toUrlString:requestString];
    NSURL *url = [NSURL URLWithString:requestString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData * _Nullable data,
                                                     NSURLResponse * _Nullable response,
                                                     NSError * _Nullable error) {
        completionHandler(error, response, data);
    }] resume];
}

- (void)attachNewPaymentMethodToCustomer:(NSString *)stripeId
                                  source:(NSString *)source
                              completion:(void(^)(NSError *, NSURLResponse *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    NSString *requestString =
    [kSurplusBaseUrl stringByAppendingString:kSurplusStripeCustomerAddNewPaymentMethodPath];
    request.URL = [NSURL URLWithString:requestString];
    NSLog(@"%@", requestString);
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *params = @{@"stripeId": stripeId,
                             @"source": source};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    request.HTTPBody = postData;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
        completionHandler(error, response, data);
    }] resume];
}

- (void)selectDefaultCustomerSource:(NSString *)stripeId
                             source:(NSString *)source
                         completion:(void(^)(NSError *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    NSString *requestString =
    [kSurplusBaseUrl stringByAppendingString:kSurplusStripeCustomerChangeDefaultPaymentMethodPath];
    request.URL = [NSURL URLWithString:requestString];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *params = @{@"stripeId": stripeId,
                             @"source": source};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    request.HTTPBody = postData;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
        completionHandler(error);
    }] resume];
}

- (void)chargeCustomerWithOrder:(Order *)order
                         source:(NSString *)source
              completionHandler:(void (^)(NSError *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    NSString *requestString =
    [kSurplusBaseUrl stringByAppendingString:kSurplusStripeChargeCustomerPath];
    request.URL = [NSURL URLWithString:requestString];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *postDataDict = [@{@"order": [order json]} mutableCopy];
    postDataDict[@"source"] = source;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDataDict
                                                       options:0
                                                         error:nil];
    request.HTTPBody = postData;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
         completionHandler(error, data);
     }] resume];
}

@end
