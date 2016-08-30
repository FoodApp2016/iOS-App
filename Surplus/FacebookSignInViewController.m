//
//  FacebookSignInViewController.m
//  Surplus
//
//  Created by Juancho Gabriel Sunga on 8/26/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "FacebookSignInViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "RestaurantListTableViewController.h"
#import "Constants.h"
#import "RequestHandler.h"
#import "Customer.h"
#import "NSUserDefaults+CustomObjectStorage.h"

@interface FacebookSignInViewController ()

@property (strong, nonatomic) FBSDKLoginButton *loginButton;

@end

@implementation FacebookSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton = [FBSDKLoginButton new];
    self.loginButton.delegate = self;
    self.loginButton.center = self.view.center;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.view addSubview:self.loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self performSegueWithIdentifier:kFacebookSignInButtonSegueIdentifier sender:nil];
    }
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if(error) {
        NSLog(@"%@", error);
        return;
    }
    
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"/me"
      parameters:@{@"fields": @"id, name"}
      HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      NSDictionary *result,
                                                      NSError *error) {
        
        NSString *name = result[@"name"];
        NSString *facebookId = result[@"id"];
        
        [[RequestHandler new] getOrCreateCustomerWithName:name
                                               facebookId:facebookId
                                        completionHandler:^(NSError *error,
                                                            NSData *data) {
            
            NSDictionary *customerDict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
            NSMutableDictionary *temp = [customerDict mutableCopy];
            temp[@"id_"] = temp[@"id"];
            [temp removeObjectForKey:@"id"];
            customerDict = [temp copy];
                                            
            Customer *customer = [[Customer alloc] initWithDict:customerDict];
            [[NSUserDefaults standardUserDefaults] saveCustomer:customer
                                                            key:kNSUserDefaultsCustomerKey];
        }];
    }];

    [self performSegueWithIdentifier:kFacebookSignInButtonSegueIdentifier sender:nil];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
