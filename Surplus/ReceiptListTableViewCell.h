//
//  ReceiptListTableViewCell.h
//  Surplus
//
//  Created by Dhruv Manchala on 9/5/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListTableViewCell.h"

@interface ReceiptListTableViewCell : ListTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftoversItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView_;

@end
