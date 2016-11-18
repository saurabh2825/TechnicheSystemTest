//
//  HomeTableViewCell.h
//  Saurabh_Techniche_Test
//
//  Created by Amit Kumar on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *setNumber;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *quentityLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end
