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

- (void)makePostRequestWithUrlString:(NSString *)urlString
                              params:(NSDictionary *)params
                   completionHandler:(completionHandler)completionHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"POST";
    request.URL = [NSURL URLWithString:urlString];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:completionHandler] resume];
}

- (void)getAllRestaurants:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusGetAllRestaurantsWithItemsPath]
                                params:@{}
                     completionHandler:completionHandler];
}

- (void)getRestaurant:(unsigned int)restaurantId
    completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *urlString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetRestaurantPath];
    
    [self makePostRequestWithUrlString:urlString
                                params:@{@"id": [NSString stringWithFormat:@"%d", restaurantId]}
                     completionHandler:completionHandler];
}

- (void)getOrCreateCustomer:(NSDictionary *)params
          completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *requestString = [kSurplusBaseUrl stringByAppendingString:kSurplusGetOrAddCustomerPath];
    [self makePostRequestWithUrlString:requestString
                                params:params
                     completionHandler:completionHandler];
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

- (void)chargeCustomerWithOrder:(Order *)order
              completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusStripeChargeCustomerPath]
                                params:@{@"order": [order json]}
                     completionHandler:completionHandler];
}

- (void)createNewRestaurant:(NSDictionary *)params
          completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusAddRestaurantPath]
                                params:params
                     completionHandler:completionHandler];
}

- (void)signRestaurantIn:(NSDictionary *)restaurantCredentials
       completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusRestaurantSignInPath]
                                params:restaurantCredentials
                     completionHandler:completionHandler];
}

- (void)submitAdditionalRestaurantInfo:(NSDictionary *)additionalInfo
                     completionHandler:(completionHandler)completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.URL = [NSURL URLWithString:[kSurplusBaseUrl stringByAppendingString:kSurplusSubmitAdditionalRestaurantInfoPath]];
    
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];
    
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
                                     completionHandler:completionHandler] resume];
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
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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






























