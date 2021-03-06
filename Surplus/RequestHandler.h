//
//  RequestHandler.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/24/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

typedef void(^completionHandler)(NSData *, NSURLResponse *, NSError *);

@interface RequestHandler : NSObject

- (void)makeGetRequestWithUrlString:(NSString *)urlString
                            headers:(NSDictionary *)headers
                  completionHandler:(completionHandler)completionHandler;

- (void)makePostRequestWithUrlString:(NSString *)urlString
                              params:(NSDictionary *)params
                   completionHandler:(completionHandler)completionHandler;

- (void)makePatchRequestWithUrlString:(NSString *)urlString
                               params:(NSDictionary *)params
                    completionHandler:(completionHandler)completionHandler;

- (void)getAllRestaurants:(completionHandler)completionHandler;

- (void)getRestaurant:(unsigned int)restaurantId
    completionHandler:(completionHandler)completionHandler;

- (void)getCustomer:(NSDictionary *)params
  completionHandler:(completionHandler)completionHandler;

- (void)getOrCreateCustomer:(NSDictionary *)params
          completionHandler:(completionHandler)completionHandler;

- (void)attachNewPaymentMethodToCustomer:(NSString *)stripeId
                                  source:(NSString *)source
                              completion:(void(^)(NSError *, NSURLResponse *, NSData *)) completionHandler;

- (void)selectDefaultCustomerSource:(NSString *)stripeId
                             source:(NSString *)source
                         completion:(void(^)(NSError *))completionHandler;

-(void)chargeCustomerWithOrder:(Order *)order
                        source:(NSString *)source
             completionHandler:(void(^)(NSError *, NSData *))completionHandler;

- (void)chargeCustomerWithOrder:(Order *)order
              completionHandler:(completionHandler)completionHandler;

- (void)createNewRestaurant:(NSDictionary *)params
          completionHandler:(completionHandler)completionHandler;

- (void)signRestaurantIn:(NSDictionary *)restaurantCredentials
       completionHandler:(completionHandler)completionHandler;

- (void)submitAdditionalRestaurantInfo:(NSDictionary *)additionalInfo
                         forRestaurant:(unsigned int)restaurantId
                     completionHandler:(completionHandler)completionHandler;

- (void)getAllOrdersForRestaurant:(unsigned int)restaurantId
                completionHandler:(completionHandler)completionHandler;

- (void)updateItem:(NSDictionary *)itemDetails
     forRestaurant:(unsigned int)restaurantId
 completionHandler:(completionHandler)completionHandler;

- (void)completeOrder:(unsigned int)orderId
    completionHandler:(completionHandler)completionHandler;

- (void)getAllOrdersForCustomer:(unsigned int)customerId
              completionHandler:(completionHandler)completionHandler;

- (void)getImageForRestaurantId:(unsigned int)restaurantId
              completionHandler:(void (^)(UIImage *))completionHandler;

- (NSURL *)displayImageUrlForRestaurantId:(unsigned int)restaurantId;

@end
