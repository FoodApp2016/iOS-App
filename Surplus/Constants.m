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
NSString *const kRestaurantUpdateItemTableViewControllerIdentifier = @"restaurantUpdateItemTableViewControllerIdentifier";
NSString *const kFacebookSignInViewControllerIdentifier = @"facebookSignInViewControllerIdentifier";
NSString *const kRestaurantTabBarControllerIdentifier = @"restaurantTabBarControllerIdentifier";
NSString *const kReceiptListTableViewCellIdentifier = @"receiptListTableViewCellIdentifier";
NSString *const kReuseIdentifier = @"reuseIdentifier";
NSString *const kRestaurantSettingsIconButtonPressSegueIdentifier = @"restaurantSettingsIconButtonPressSegueIdentifier";
NSString *const kFacebookSignInViewControllerBusinessSignUpButtonSegueIdentifier = @"facebookSignInViewControllerBusinessSignUpButtonSegueIdentifier";
NSString *const kFacebookSignInViewControllerBusinessLoginButtonSegueIdentifier = @"facebookSignInViewControllerBusinessLoginButtonSegueIdentifier";

NSString *const kSurplusBaseUrl = @"https://surplus-app.herokuapp.com";
NSString *const kSurplusRestlessBaseUrl = //@"http://0.0.0.0:5000";
                                    //@"https://surplus-stage.herokuapp.com";
                                    @"https://surplus-app.herokuapp.com/api";
                                    //@"http://216.243.61.223:5000";
NSString *const kSurplusGetAllRestaurantsPath = @"/restaurants/all";
NSString *const kSurplusGetAllRestaurantsWithItemsPath = @"/restaurants/get_all_restaurants_with_items";
NSString *const kSurplusRetrieveCustomerSourcesPath = @"/customer/retrieve_sources";
NSString *const kSurplusAddNewCustomerPaymentSourcePath = @"/customer/new_payment_source";
NSString *const kSurplusSelectNewDefaultCustomerSourcePath = @"/customer/select_new_default_payment_source";
NSString *const kSurplusStripeChargeCustomerPath = @"/customers/stripe/charge";
NSString *const kSurplusCustomerPath = @"/customer";
NSString *const kSurplusOrderPath = @"/order";
NSString *const kSurplusGetCustomerOrdersPath = @"/customer/orders";
NSString *const kSurplusRestaurantLoginPath = @"/restaurant/login";
NSString *const kSurplusRestaurantPath = @"/restaurant";
NSString *const kSurplusGetAllRestaurantOrdersPath = @"/restaurant/orders";
NSString *const kSurplusSubmitAdditionalRestaurantInfoPath =  @"/restaurant/submit_additional_info";
NSString *const kSurplusGetAllOrdersByRestaurantIdPath = @"/orders/get_all_orders_by_restaurant_id";
NSString *const kSurplusGetAllOrdersByCustomerIdPath = @"/orders/get_orders_by_customer_id";
NSString *const kSurplusUpdateItemPath = @"/restaurants/update_item";
NSString *const kSurplusCompleteOrderPath = @"/ordes/order_completed";
NSString *const kSurplusGetRestaurantImagePath = @"/uploads/displayImage";

NSString *const kStripePublishableKey = @"pk_live_sMlwPAHrUMKAIjeuLvXpSh1l";

NSString *const kNSUserDefaultsCustomerKey = @"NSUserDefaultsCustomerKey";
NSString *const kNSUserDefaultsRestaurantKey = @"NSUserDefaultsRestaurantKey";

NSString *const kTestStripeId = @"cus_95vTF2ZS0o9bWw";

NSString *const kFontAwesomeStar = @"";
NSString *const kFontAwesomePlusSquare = @"";

NSString *const kFeedbackEmailId = @"jsunga16@students.claremontmckenna.edu";

NSString *const kNoStripeSourcesPlaceholderText = @"Select Method";

