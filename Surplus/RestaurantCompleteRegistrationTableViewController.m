//
//  RestaurantCompleteRegistrationTableViewController.m
//  Surplus
//
//  Created by Dhruv Manchala on 9/6/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import "RestaurantCompleteRegistrationTableViewController.h"
#import "Constants.h"
#import "RequestHandler.h"
#import "NSUserDefaults+CustomObjectStorage.h"
#import "RequestHandler.h"

@interface RestaurantCompleteRegistrationTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation RestaurantCompleteRegistrationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.descriptionTextView.delegate = self;
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        if (self.profileImageView.image == nil) {
            return 0;
        }
        return 216;
    }
    
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return indexPath.row == 2;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    self.profileImageView.image = nil;
    [self.profileImageButton setTitle:kFontAwesomePlusSquare forState:UIControlStateNormal];
    self.profileImageButton.titleLabel.font = [self.profileImageButton.titleLabel.font fontWithSize:25];
    [self.profileImageButton sizeToFit];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.descriptionTextView.text isEqual:@""]) {
        self.descriptionPlaceholderLabel.hidden = NO;
    }
    else {
        self.descriptionPlaceholderLabel.hidden = YES;
    }
}

- (IBAction)profileImageButtonPressed:(id)sender {
    
    if ([self.profileImageButton.titleLabel.text isEqual:kFontAwesomePlusSquare]) {
        [self.navigationController presentViewController:self.imagePickerController
                                                animated:YES
                                              completion:nil];
        return;
    }
    
    else {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    self.profileImageView.image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.profileImageButton setTitle:@"Edit" forState:UIControlStateNormal];
    self.profileImageButton.titleLabel.font = [self.profileImageButton.titleLabel.font fontWithSize:17];
    [self.profileImageButton sizeToFit];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)nextButtonPressed:(id)sender {
    
    [super displayOrHideCompleteAllFieldsHeaderIfRequired];
    
    if (![self allFieldsAreComplete]) {
        return;
    }
    
    Restaurant *restaurant = [[NSUserDefaults standardUserDefaults] loadRestaurantWithKey:kNSUserDefaultsRestaurantKey];
    NSString *profileImageString = [UIImagePNGRepresentation(self.profileImageView.image)
                                    base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [[RequestHandler new] submitAdditionalRestaurantInfo:@{@"description": self.descriptionTextView.text,
                                                           @"profileImage": profileImageString,
                                                           @"username": restaurant.username,
                                                           @"password": restaurant.password}
                                       completionHandler:^(NSData *data,
                                                           NSURLResponse *response,
                                                           NSError *error) {
                                           
        if (error) {
           NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
           return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&error];

        if (error) {
           NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
           return;
        }

        if (![json[@"success"] boolValue]) {
           NSLog(@"%s %@", __PRETTY_FUNCTION__, json);
           return;
        }

        restaurant.description_ = self.descriptionTextView.text;
        restaurant.displayImage = self.profileImageView.image;

        [[NSUserDefaults standardUserDefaults] saveRestaurant:restaurant
                                                     key:kNSUserDefaultsRestaurantKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:kCompleteProfileViewControllerDoneButtonSegueIdentifier sender:nil];
        });
    }];
}

@end




