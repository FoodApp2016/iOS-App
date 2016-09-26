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

- (void)getAllRestaurants:(void(^)(NSError *, NSData *))completionHandler;

- (void)getRestaurant:(unsigned int)restaurantId
    completionHandler:(completionHandler)completionHandler;

- (void)getOrCreateCustomerWithName:(NSString *)name
                         facebookId:(NSString *)facebookId
                  completionHandler:(void(^)(NSError *, NSData *))completionHandler;

- (void)getStripeCustomer:(NSString *)customer
        completionHandler:(void(^)(NSError *, NSURLResponse *, NSData *))completionHandler;

- (void)attachNewPaymentMethodToCustomer:(NSString *)stripeId
                                  source:(NSString *)source
                              completion:(void(^)(NSError *, NSURLResponse *, NSData *)) completionHandler;

- (void)selectDefaultCustomerSource:(NSString *)stripeId
                             source:(NSString *)source
                         completion:(void(^)(NSError *))completionHandler;

-(void)chargeCustomerWithOrder:(Order *)order
                        source:(NSString *)source
             completionHandler:(void(^)(NSError *, NSData *))completionHandler;

- (void)createNewRestaurantWithUsername:(NSString *)username
                               password:(NSString *)password
                                   name:(NSString *)name
                            phoneNumber:(NSString *)phoneNumber
                      completionHandler:(completionHandler)completionHandler;

- (void)signRestaurantIn:(NSDictionary *)restaurantCredentials
       completionHandler:(completionHandler)completionHandler;

- (void)submitAdditionalRestaurantInfo:(NSDictionary *)additionalInfo
                     completionHandler:(completionHandler)completionHandler;

- (void)getAllOrdersForRestaurant:(unsigned int)restaurantId
                completionHandler:(completionHandler)completionHandler;

- (void)updateItem:(NSDictionary *)itemDetails
 completionHandler:(completionHandler)completionHandler;

- (void)completeOrder:(unsigned int)orderId
    completionHandler:(completionHandler)completionHandler;

- (void)getAllOrdersForCustomer:(unsigned int)customerId
              completionHandler:(completionHandler)completionHandler;

- (void)getImageForRestaurantId:(unsigned int)restaurantId
              completionHandler:(completionHandler)completionHandler;

@end
