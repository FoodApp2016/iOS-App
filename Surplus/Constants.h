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
extern NSString *const kRestaurantLoginViewControllerLoginButtonSegueIdentifier;
extern NSString *const kCompleteProfileViewControllerDoneButtonSegueIdentifier;
extern NSString *const kRestaurantUpdateItemTableViewControllerIdentifier;
extern NSString *const kFacebookSignInViewControllerIdentifier;
extern NSString *const kRestaurantTabBarControllerIdentifier;
extern NSString *const kReceiptListTableViewCellIdentifier;
extern NSString *const kReuseIdentifier;
extern NSString *const kRestaurantSettingsIconButtonPressSegueIdentifier;
extern NSString *const kFacebookSignInViewControllerBusinessSignUpButtonSegueIdentifier;
extern NSString *const kFacebookSignInViewControllerBusinessLoginButtonSegueIdentifier;

extern NSString *const kSurplusBaseUrl;
extern NSString *const kSurplusRestlessBaseUrl;
extern NSString *const kSurplusGetAllRestaurantsPath;
extern NSString *const kSurplusGetAllRestaurantsWithItemsPath;
extern NSString *const kSurplusRetrieveCustomerSourcesPath;
extern NSString *const kSurplusAddNewCustomerPaymentSourcePath;
extern NSString *const kSurplusSelectNewDefaultCustomerSourcePath;
extern NSString *const kSurplusStripeChargeCustomerPath;
extern NSString *const kSurplusCustomerPath;
extern NSString *const kSurplusOrderPath;
extern NSString *const kSurplusGetCustomerOrdersPath;
extern NSString *const kSurplusRestaurantLoginPath;
extern NSString *const kSurplusRestaurantPath;
extern NSString *const kSurplusGetAllRestaurantOrdersPath;
extern NSString *const kSurplusSubmitAdditionalRestaurantInfoPath;
extern NSString *const kSurplusGetAllOrdersByRestaurantIdPath;
extern NSString *const kSurplusGetAllOrdersByCustomerIdPath;
extern NSString *const kSurplusUpdateItemPath;
extern NSString *const kSurplusCompleteOrderPath;
extern NSString *const kSurplusGetRestaurantImagePath;

extern NSString *const kStripePublishableKey;

extern NSString *const kNSUserDefaultsCustomerKey;
extern NSString *const kNSUserDefaultsRestaurantKey;

extern NSString *const kTestStripeId;

extern NSString *const kFontAwesomeStar;
extern NSString *const kFontAwesomePlusSquare;

extern NSString *const kFeedbackEmailId;

extern NSString *const kNoStripeSourcesPlaceholderText;

#endif /* Constants_h */
