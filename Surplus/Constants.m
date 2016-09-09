//
//  Constants.m
//  Surplus
//
//  Created by Dhruv Manchala on 8/18/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "Constants.h"

NSString *const kRestaurantListTableViewCellIdentifier = @"restaurantListTableViewCellIdentifier";
NSString *const kRestaurantListTableViewCellSegueIdentifier = @"restaurantListTableViewCellSegueIdentifier";
NSString *const kRestaurantViewControllerOrderButtonSegueIdentifier = @"restaurantViewControllerOrderButtonSegueIdentifier";
NSString *const kFacebookSignInButtonSegueIdentifier = @"facebookSignInButtonSegueIdentifier";
NSString *const kRestaurantLoginViewControllerLoginButtonSegueIdentifier = @"restaurantLoginViewControllerLoginButtonSegueIdentifier";
NSString *const kCompleteProfileViewControllerDoneButtonSegueIdentifier = @"completeProfileViewControllerDoneButtonSegueIdentifier";

NSString *const kSurplusBaseUrl = // @"http://0.0.0.0:5000";
    @"https://surplus-stage.herokuapp.com";
NSString *const kSurplusGetAllRestaurantsPath = @"/restaurants/all";
NSString *const kSurplusGetStripeCustomerPath = @"/customers/stripe";
NSString *const kSurplusStripeCustomerAddNewPaymentMethodPath = @"/customers/stripe/newpaymentmethod";
NSString *const kSurplusStripeCustomerChangeDefaultPaymentMethodPath = @"/customers/stripe/changedefaultpaymentmethod";
NSString *const kSurplusStripeChargeCustomerPath = @"/customers/stripe/charge";
NSString *const kSurplusGetOrAddCustomerPath = @"/customers/getoradd";
NSString *const kSurplusAddRestaurantPath = @"/restaurants/create_new_restaurant";
NSString *const kSurplusRestaurantSignInPath = @"/restaurants/sign_in";
NSString *const kSurplusSubmitAdditionalRestaurantInfoPath = @"/restaurants/submit_additional_info";

NSString *const kStripePublishableKey = @"pk_test_WtOtIVWN2IMyqREQteqgUVC4";

NSString *const kNSUserDefaultsCustomerKey = @"NSUserDefaultsCustomerKey";
NSString *const kNSUserDefaultsRestaurantKey = @"NSUserDefaultsRestaurantKey";

NSString *const kTestStripeId = @"cus_95vTF2ZS0o9bWw";

NSString *const kFontAwesomeStar = @"";
NSString *const kFontAwesomePlusSquare = @"";
