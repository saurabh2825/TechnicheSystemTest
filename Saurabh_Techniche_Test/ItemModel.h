//
//  ItemModel.h
//  Saurabh_Techniche_Test
//
//  Created by Amit Kumar on 2016-11-17.
//  Copyright © 2016 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property(nonatomic , strong)NSString *foodName;

@property(nonatomic , strong)NSString *foodWeight;

@property(nonatomic , strong)NSString *numberOfQuantity;

@property (nonatomic ,strong) NSString * foodCost;

@property (nonatomic) NSInteger cartCount;
@property (nonatomic, strong) NSString * imageCode;
@property (nonatomic, strong) NSString * code;
@end
