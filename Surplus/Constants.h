//
//  Constants.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/18/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#import <Foundation/Foundation.h>

extern NSString *const kRestaurantListTableViewCellIdentifier;
extern NSString *const kRestaurantListTableViewCellSegueIdentifier;
extern NSString *const kRestaurantViewControllerOrderButtonSegueIdentifier;
extern NSString *const kFacebookSignInButtonSegueIdentifier;

extern NSString *const kSurplusBaseUrl;
extern NSString *const kSurplusGetAllRestaurantsPath;
extern NSString *const kSurplusGetStripeCustomerPath;
extern NSString *const kSurplusStripeCustomerAddNewPaymentMethodPath;
extern NSString *const kSurplusStripeCustomerChangeDefaultPaymentMethodPath;
extern NSString *const kSurplusStripeChargeCustomerPath;
extern NSString *const kSurplusGetOrAddCustomerPath;

extern NSString *const kStripePublishableKey;

extern NSString *const kNSUserDefaultsCustomerKey;

extern NSString *const kTestStripeId;

#endif /* Constants_h */
