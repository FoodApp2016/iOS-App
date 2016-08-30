//
//  RequestHandler.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/24/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface RequestHandler : NSObject

- (void)getAllRestaurants:(void(^)(NSError *, NSData *))completionHandler;
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

@end
