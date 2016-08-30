//
//  StripeAPIAdapter.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/26/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "StripeApiAdapter.h"
#import "Customer.h"
#import "Constants.h"
#import "RequestHandler.h"
#import "NSUserDefaults+CustomObjectStorage.h"

@implementation StripeApiAdapter

- (void)retrieveCustomer:(STPCustomerCompletionBlock)completion {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    NSLog(@"%@", customer.stripeId);
    
    [[RequestHandler new] getStripeCustomer:customer.stripeId
                          completionHandler:^(NSError *error,
                                              NSURLResponse *response,
                                              NSData *customerData) {
                              
        dispatch_async(dispatch_get_main_queue(), ^{
         
          STPCustomerDeserializer *deserializer = [[STPCustomerDeserializer alloc]
                                                   initWithData:customerData
                                                   urlResponse:response error:error];
        
          if (error != nil) {
              completion(nil, error);
              return;
          }
          
          completion(deserializer.customer, nil);
        });
    }];
}

- (void)attachSourceToCustomer:(id<STPSource>)source completion:(STPErrorBlock)completion {
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    [[RequestHandler new] attachNewPaymentMethodToCustomer:customer.stripeId
                                                    source:source.stripeID
                                                completion:^(NSError *error,
                                                             NSURLResponse *response,
                                                             NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }];
}

- (void)selectDefaultCustomerSource:(id<STPSource>)source completion:(STPErrorBlock)completion {
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    [[RequestHandler new] selectDefaultCustomerSource:customer.stripeId
                                               source:source.stripeID
                                           completion:^(NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           completion(error);
       });
    }];
}

@end
