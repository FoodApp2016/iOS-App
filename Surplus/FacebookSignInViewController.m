

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
#import "Restaurant.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "RestaurantUpdateItemTableViewController.h"
#import "Constants.h"

@interface FacebookSignInViewController ()

@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *businessLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *businessSignUpButton;

@end

@implementation FacebookSignInViewController

- (void)viewDidLoad {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewDidLoad];
    
    // Don't change order - the y position of each element depends on the ones before it
    [self createLoginButton];
    [self createSurplusLabel];
    [self configureBusinessButtons];

    self.backgroundImageView.image = [UIImage imageNamed:@"beef-fried-rice-2-edited.jpg"];
    
    if ([self restaurantExists]) {
        [self segueToRestaurantDashboard];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createLoginButton {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.loginButton = [FBSDKLoginButton new];
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    float x = self.view.center.x - self.loginButton.frame.size.width / 2;
    float y = self.view.frame.size.height - self.loginButton.frame.size.height - 325;
    [self.loginButton setFrame:CGRectMake(x,
                                          y,
                                          self.loginButton.frame.size.width,
                                          self.loginButton.frame.size.height)];
    [self.view addSubview:self.loginButton];
}

- (void)createSurplusLabel {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.surplusLabel = [UILabel new];
    self.surplusLabel.text = @"SURPLUS";
    self.surplusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36.];
    self.surplusLabel.textColor = [UIColor whiteColor];
    [self.surplusLabel sizeToFit];
    
    float x = self.view.center.x - self.surplusLabel.frame.size.width / 2;
    float y = self.view.frame.origin.x + 50;
    [self.surplusLabel setFrame:CGRectMake(x,
                                           y,
                                           self.surplusLabel.frame.size.width,
                                           self.surplusLabel.frame.size.height)];
    [self.view addSubview:self.surplusLabel];
}

- (void)configureBusinessButtons {
    self.businessLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.businessLoginButton setTitle:@"Business Login" forState:UIControlStateNormal];
    [self.businessLoginButton addTarget:nil
                                 action:@selector(segueToRestaurantLoginViewController)
                       forControlEvents:UIControlEventTouchUpInside];
    [self configureBusinessButton:self.businessLoginButton];
    
    float x = self.view.center.x - self.loginButton.frame.size.width / 2;
    float y = self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 240;
    [self.businessLoginButton setFrame:CGRectMake(x,
                                                  y,
                                                  self.loginButton.frame.size.width,
                                                  self.loginButton.frame.size.height)];
    [self.view addSubview:self.businessLoginButton];
    
    
    self.businessSignUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.businessSignUpButton setTitle:@"Business Sign Up" forState:UIControlStateNormal];
    [self.businessSignUpButton addTarget:nil
                                  action:@selector(segueToRestaurantSignUpViewController)
                        forControlEvents:UIControlEventTouchUpInside];
    [self configureBusinessButton:self.businessSignUpButton];
    
    x = self.view.center.x - self.loginButton.frame.size.width / 2;
    y = self.businessLoginButton.frame.origin.y + self.businessLoginButton.frame.size.height + 8;
    [self.businessSignUpButton setFrame:CGRectMake(x,
                                                   y,
                                                   self.loginButton.frame.size.width,
                                                   self.loginButton.frame.size.height)];
    [self.view addSubview:self.businessSignUpButton];
    
    
}

- (void)segueToRestaurantLoginViewController {
    
    [self performSegueWithIdentifier:kFacebookSignInViewControllerBusinessLoginButtonSegueIdentifier sender:nil];
}

- (void)segueToRestaurantSignUpViewController {
   
    [self performSegueWithIdentifier:kFacebookSignInViewControllerBusinessSignUpButtonSegueIdentifier
                              sender:nil];
}

- (void)configureBusinessButton:(UIButton *)button {
    
    button.titleLabel.font = [button.titleLabel.font fontWithSize:14];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    button.layer.cornerRadius = 3.5;
    button.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [button sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewDidAppear:animated];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self performSegueWithIdentifier:kFacebookSignInButtonSegueIdentifier sender:nil];
    }
}

- (void)segueToRestaurantDashboard {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"restaurantTabBarControllerIdentifier"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
    });
}

- (BOOL)restaurantExists {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults]
                              loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    return restaurant != nil;
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (error) {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
        return;
    }
    
    if (result.isCancelled) {
        return;
    }

    [self getOrCreateCustomer];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)createCustomerObjectAndSaveToNSUserDefaults:(NSDictionary *)customerDict {
    
    NSMutableDictionary *temp = [customerDict mutableCopy];
    temp[@"id_"] = temp[@"id"];
    [temp removeObjectForKey:@"id"];
    temp[@"stripeId"] = temp[@"stripeID"];
    [temp removeObjectForKey:@"stripeID"];
    
    Customer *customer = [[Customer alloc] initWithDict:[temp copy]];
    [[NSUserDefaults standardUserDefaults] saveCustomer:customer
                                                    key:kNSUserDefaultsCustomerKey];
}

- (void)getOrCreateCustomer {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[[FBSDKGraphRequest alloc]
      initWithGraphPath:@"/me"
      parameters:@{@"fields": @"id, name"}
      HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      NSDictionary *result,
                                                      NSError *error) {
        
        NSDictionary *params = @{@"name": result[@"name"],
                                 @"facebookID": result[@"id"]};
        
        [[RequestHandler new] getCustomer:params completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
            if (error) {
                NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                return;
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
            
            if (error) {
                NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                return;
            }
            
            if ([dict[@"objects"] count] == 0) {
                
                NSString *urlString = [kSurplusRestlessBaseUrl stringByAppendingString:kSurplusCustomerPath];
                
                [[RequestHandler new] makePostRequestWithUrlString:urlString
                                            params:params
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                    if (error) {
                        NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                        return;
                    }
                    
                    NSDictionary *customerDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:nil];
                    
                    if (error) {
                        NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
                        return;
                    }
        
                    [self createCustomerObjectAndSaveToNSUserDefaults:customerDict];
                }];
                
                return;
            }
            
            NSDictionary *customerDict = dict[@"objects"][0];
            [self createCustomerObjectAndSaveToNSUserDefaults:customerDict];
        }];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.navigationController.navigationBar.hidden = NO;
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
