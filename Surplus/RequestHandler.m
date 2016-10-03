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


- (void)getRestaurant:(unsigned int)restaurantId
    completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *urlString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetRestaurantPath];
    
    [self makePostRequestWithUrlString:urlString
                                params:@{@"id": [NSString stringWithFormat:@"%d", restaurantId]}
                     completionHandler:completionHandler];
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
    
    NSLog(@"%@", [order json]);
    
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
    request.URL = [NSURL URLWithString:[kSurplusBaseUrl stringByAppendingString:kSurplusSubmitAdditionalRestaurantInfoPath]];
    
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPMethod = @"POST";
    
    NSMutableData *body = [NSMutableData data];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:additionalInfo[@"profileImage"]];
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
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set request body
    [request setHTTPBody:body];
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data,
                                                         NSURLResponse * _Nullable response,
                                                         NSError * _Nullable error) {
                                         
        completionHandler(data, response, error);
    }] resume];
}

- (void)getAllOrdersForRestaurant:(unsigned int)restaurantId
                completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusGetAllOrdersByRestaurantIdPath]
                                params:@{@"restaurantId": [NSString stringWithFormat:@"%d", restaurantId]}
                     completionHandler:completionHandler];
}

- (void)getAllOrdersForCustomer:(unsigned int)customerId
              completionHandler:(completionHandler)completionHandler {
    
    NSString *urlString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetAllOrdersByCustomerIdPath];
    
    [self makePostRequestWithUrlString:urlString
                                params:@{@"customerId": [NSString stringWithFormat:@"%d", customerId]}
                                         completionHandler:completionHandler];
}

- (void)updateItem:(NSDictionary *)itemDetails
 completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *urlString = [kSurplusBaseUrl stringByAppendingString:kSurplusUpdateItemPath];
    
    [self makePostRequestWithUrlString:urlString
                                params:itemDetails
                     completionHandler:completionHandler];
}

- (void)completeOrder:(unsigned int)orderId
    completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *urlString = [kSurplusBaseUrl stringByAppendingString:kSurplusCompleteOrderPath];
    
    [self makePostRequestWithUrlString:urlString
                                params:@{@"id": [NSString stringWithFormat:@"%d", orderId]}
                     completionHandler:completionHandler];
}

- (void)getImageForRestaurantId:(unsigned int)restaurantId
              completionHandler:(void (^)(UIImage *))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSURL *imageUrl = [[RequestHandler new] displayImageUrlForRestaurantId:restaurantId];
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        // Make a trivial (1x1) graphics context, and draw the image into it
        UIGraphicsBeginImageContext(CGSizeMake(1,1));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
        UIGraphicsEndImageContext();
        
        // Now the image will have been loaded and decoded and is ready to rock for the main thread
        completionHandler(image);
    });
}

- (NSURL *)displayImageUrlForRestaurantId:(unsigned int)restaurantId {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%d.jpg",
                           kSurplusBaseUrl,
                           kSurplusGetRestaurantImagePath,
                           restaurantId];
    
    return [NSURL URLWithString:urlString];
}

@end






























