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

- (void)makePostRequestWithUrlString:(NSString *)urlString
                              params:(NSDictionary *)params
                   completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    request.URL = [NSURL URLWithString:urlString];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    NSLog(@"%@", params);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
         completionHandler(data, response, error);
     }] resume];
}

- (void)getAllRestaurants:(void (^)(NSError *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusGetAllRestaurantsWithItemsPath]
                                params:@{}
                     completionHandler:^(NSData *data,
                                         NSURLResponse *response,
                                         NSError *error) {
        completionHandler(error, data);
    }];
}

- (void)getOrCreateCustomerWithName:(NSString *)name
                         facebookId:(NSString *)facebookId
                  completionHandler:(void (^)(NSError *, NSData *))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *requestString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetOrAddCustomerPath];
    [self makePostRequestWithUrlString:requestString
                  params:@{@"name": name, @"facebookId": facebookId}
       completionHandler:^(NSData *data,
                           NSURLResponse *response,
                           NSError *error) {
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

- (void)createNewRestaurantWithUsername:(NSString *)username
                               password:(NSString *)password
                                   name:(NSString *)name
                            phoneNumber:(NSString *)phoneNumber
                      completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSDictionary *params = @{@"username": username,
                             @"password": password,
                             @"name": name,
                             @"phoneNumber": phoneNumber};
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusAddRestaurantPath]
                                params:params
                     completionHandler:^(NSData *data,
                                         NSURLResponse *response,
                                         NSError *error) {
        completionHandler(data, response, error);
    }];
}

- (void)signRestaurantIn:(NSDictionary *)restaurantCredentials
       completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusRestaurantSignInPath]
                                params:restaurantCredentials
                     completionHandler:^(NSData *data,
                                         NSURLResponse *response,
                                         NSError *error) {
        completionHandler(data, response, error);
    }];
}

- (void)submitAdditionalRestaurantInfo:(NSDictionary *)additionalInfo
                     completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    request.URL = [NSURL URLWithString:[kSurplusBaseUrl stringByAppendingString:kSurplusSubmitAdditionalRestaurantInfoPath]];
    
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    request.HTTPMethod = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableData *body = [NSMutableData data];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\".png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:additionalInfo[@"profileImage"]]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[additionalInfo[@"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[additionalInfo[@"password"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[additionalInfo[@"description"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
                                         
        completionHandler(data, response, error);
    }] resume];
}

- (void)getAllOrdersForRestaurant:(int)restaurantId
                completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusGetAllOrdersByRestaurantIdPath]
                                params:@{@"restaurantId": [NSString stringWithFormat:@"%d", restaurantId]}
                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        completionHandler(data, response, error);
    }];
}

@end






























