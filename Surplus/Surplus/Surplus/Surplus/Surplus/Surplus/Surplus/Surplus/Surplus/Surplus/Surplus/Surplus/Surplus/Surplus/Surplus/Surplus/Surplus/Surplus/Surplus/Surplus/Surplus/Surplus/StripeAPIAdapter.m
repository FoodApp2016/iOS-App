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

    [[RequestHandler new] makeGetRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusRetrieveCustomerSourcesPath]
                                              headers:@{@"customerID": [NSString stringWithFormat:@"%d", customer.id_]}
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{

            if (error != nil) {
                completion(nil, error);
                return;
            }
            
            STPCustomerDeserializer *deserializer = [[STPCustomerDeserializer alloc]
                                                     initWithData:data
                                                     urlResponse:response error:error];
          
            completion(deserializer.customer, nil);
        });
    }];
}

- (void)attachSourceToCustomer:(id<STPSource>)source completion:(STPErrorBlock)completion {
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    [[RequestHandler new] makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusAddNewCustomerPaymentSourcePath]
                                                params:@{@"customerID": [NSString stringWithFormat:@"%d", customer.id_],
                                                         @"source": source.stripeID}
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }];
}

- (void)selectDefaultCustomerSource:(id<STPSource>)source completion:(STPErrorBlock)completion {
    
    Customer *customer = [[NSUserDefaults standardUserDefaults] loadCustomerWithKey:kNSUserDefaultsCustomerKey];
    
    [[RequestHandler new] makePostRequestWithUrlString:[kSurplusBaseUrl stringByAppendingString:kSurplusSelectNewDefaultCustomerSourcePath]
                                                params:@{@"customerID": [NSString stringWithFormat:@"%d", customer.id_],
                                                         @"source": source.stripeID}
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
         completion(error);
        });
    }];
}

@end
