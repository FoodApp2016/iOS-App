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

@interface FacebookSignInViewController ()

@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *businessLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *businessSignUpButton;

@end

@implementation FacebookSignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Don't change order - the y position of each element depends on the ones before it
    [self createLoginButton];
    [self createSurplusLabel];
    [self configureBusinessButtons];

    self.backgroundImageView.image = [UIImage imageNamed:@"beef-fried-rice-2-edited.jpg"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createLoginButton {
    
    self.loginButton = [FBSDKLoginButton new];
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    float x = self.view.center.x - self.loginButton.frame.size.width / 2;
    float y = self.view.frame.size.height - self.loginButton.frame.size.height - 100;
    [self.loginButton setFrame:CGRectMake(x,
                                          y,
                                          self.loginButton.frame.size.width,
                                          self.loginButton.frame.size.height)];
    [self.view addSubview:self.loginButton];
}

- (void)createSurplusLabel {
    
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
    
    self.businessSignUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.businessSignUpButton setTitle:@"Business Sign Up" forState:UIControlStateNormal];
    [self.businessSignUpButton addTarget:nil
                                  action:@selector(segueToRestaurantSignUpViewController)
                        forControlEvents:UIControlEventTouchUpInside];
    [self configureBusinessButton:self.businessSignUpButton];
    
    float x = self.view.center.x - self.loginButton.frame.size.width / 2;
    float y = self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 8;
    [self.businessSignUpButton setFrame:CGRectMake(x,
                                                   y,
                                                   self.loginButton.frame.size.width,
                                                   self.loginButton.frame.size.height)];
    [self.view addSubview:self.businessSignUpButton];
    
    self.businessLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.businessLoginButton setTitle:@"Business Login" forState:UIControlStateNormal];
    [self.businessLoginButton addTarget:nil
                                  action:@selector(segueToRestaurantLoginViewController)
                        forControlEvents:UIControlEventTouchUpInside];
    [self configureBusinessButton:self.businessLoginButton];
    
    x = self.view.center.x - self.loginButton.frame.size.width / 2;
    y = self.businessSignUpButton.frame.origin.y + self.businessSignUpButton.frame.size.height + 8;
    [self.businessLoginButton setFrame:CGRectMake(x,
                                                  y,
                                                  self.loginButton.frame.size.width,
                                                  self.loginButton.frame.size.height)];
    [self.view addSubview:self.businessLoginButton];
    
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
    
    [super viewDidAppear:animated];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self getOrCreateCustomer];
        [self performSegueWithIdentifier:kFacebookSignInButtonSegueIdentifier sender:nil];
        return;
    }
    
    if ([self restaurantExists]) {
        
    }
}

- (void)segueToRestaurantDashboard {
    
}

- (BOOL)restaurantExists {
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults]
                              loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    
    return restaurant != nil;
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    if (result.isCancelled) {
        return;
    }

    [self getOrCreateCustomer];
    [self performSegueWithIdentifier:kFacebookSignInButtonSegueIdentifier sender:nil];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (void)getOrCreateCustomer {
    
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
