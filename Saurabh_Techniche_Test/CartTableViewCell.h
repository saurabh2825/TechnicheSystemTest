//
//  CartTableViewCell.h
//  Saurabh_Techniche_Test
//
//  Created by Saurabh Suman on 2016-11-18.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *pricePerProduct;

@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UIButton *decrementButton;

@property (weak, nonatomic) IBOutlet UIView *amountholderView;

@end
